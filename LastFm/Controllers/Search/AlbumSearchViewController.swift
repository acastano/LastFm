import UIKit
import RxSwift

final class AlbumSearchViewController: UIViewController {
    static func controller(repository: AlbumRepository, navigatior: Navigator, keyboardManager: KeyboardManager = KeyboardManagerImpl()) -> AlbumSearchViewController? {
        let controller = UIStoryboard.instantiateViewController(className(), anyClass: self) as? AlbumSearchViewController
        controller?.navigator = navigatior
        controller?.repository = repository
        controller?.keyboardManager = keyboardManager
        return controller
    }

    private let cellIdentifier = "cell"
    private var disposeBag = DisposeBag()
    private let defaultCellHeight = CGFloat(90)

    let searchText = Variable<String>("")

    private var navigator: Navigator?
    private var repository: AlbumRepository?
    private var keyboardManager: KeyboardManager?

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        title = NSLocalizedString("AlbumSearchViewControllerTitle", comment: "")
        contentLabel.text = NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: "")
        searchBar.placeholder = NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: "")

        tableView.estimatedRowHeight = defaultCellHeight
        tableView.rowHeight = UITableView.automaticDimension

        keyboardManager?.updateTarget(view, scrollView: tableView)

        setupObservables()
    }

    func setupObservables() {
        setupSearchBar()
        setupTableView()
    }

    private func setupSearchBar() {
        searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.searchText.value = query
                self?.configureUsingQuery(query)
            }).disposed(by: disposeBag)
    }

    private func configureUsingQuery(_ query: String) {
        if query.isEmpty {
            tableView.isHidden = true
            contentLabel.isHidden = false
            contentLabel.text = NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: "")
        } else {
            contentLabel.text = NSLocalizedString("LoadingText", comment: "")
        }
    }

    private func configureNoContent(albums: [AlbumViewModel]) {
        tableView.isHidden = albums.count == 0
        contentLabel.isHidden = albums.count > 0
        contentLabel.text = NSLocalizedString("NoContentText", comment: "")
    }

    private func setupTableView() {
        let results = searchText
            .asObservable()
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[AlbumViewModel]> in
                if let strongSelf = self, !query.isEmpty {
                    return strongSelf.searchAlbums(query)
                }
                return Observable.empty()
        }

        results.observeOn(MainScheduler.instance).map { [weak self] albums -> [AlbumViewModel] in
            self?.configureNoContent(albums: albums)
            return albums
        }.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) {
            (index, album: AlbumViewModel, cell) in
            let cell = cell as? AlbumViewCell
            cell?.configure(album)
            }
            .disposed(by: self.disposeBag)

        tableView.rx
            .modelSelected(AlbumViewModel.self)
            .subscribe(onNext:  { [weak self] album in
                if let strongSelf = self {
                    strongSelf.navigator?.toAlbumDetails(album)
                }
            })
            .disposed(by: disposeBag)
    }

    private func searchAlbums(_ query: String) -> Observable<[AlbumViewModel]> {
        return repository?.search(query).catchErrorJustReturn([]) ?? Observable.just([])
    }
}
