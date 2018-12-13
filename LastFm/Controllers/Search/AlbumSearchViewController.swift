import UIKit
import RxSwift

final class AlbumSearchViewController: UIViewController {
    static func controller(repository: AlbumRepository, navigatior: Navigator, keyboardManager: KeyboardManager = KeyboardManagerImpl()) -> AlbumSearchViewController? {
        let controller = UIStoryboard.instantiateViewController(className(), anyClass: self) as? AlbumSearchViewController
        controller?.navigator = navigatior
        controller?.keyboardManager = keyboardManager
        controller?.viewModel = AlbumSearchViewModel(repository: repository)
        return controller
    }

    private let cellIdentifier = "cell"
    private var disposeBag = DisposeBag()
    private let defaultCellHeight = CGFloat(90)

    var viewModel: AlbumSearchViewModel?

    private var navigator: Navigator?
    private var keyboardManager: KeyboardManager?

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        title = NSLocalizedString("AlbumSearchViewControllerTitle", comment: "")
        loadingLabel.text = NSLocalizedString("LoadingText", comment: "")
        searchBar.placeholder = NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: "")

        tableView.estimatedRowHeight = defaultCellHeight
        tableView.rowHeight = UITableView.automaticDimension

        keyboardManager?.updateTarget(view, scrollView: tableView)

        setupObservables()
    }

    func setupObservables() {
        setupLabels()
        setupSearchBar()
        setupTableView()
    }

    private func setupSearchBar() {
        searchBar.rx.text.orEmpty
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.viewModel?.updateQuery(query)
            }).disposed(by: disposeBag)
    }

    private func setupLabels() {
        viewModel?.contentText.bind(to: contentLabel.rx.text).disposed(by: disposeBag)
        viewModel?.contentHidden.bind(to: contentLabel.rx.isHidden).disposed(by: disposeBag)
        viewModel?.loadingHidden.bind(to: loadingLabel.rx.isHidden).disposed(by: disposeBag)
    }

    private func setupTableView() {
        viewModel?.tableHidden.bind(to: tableView.rx.isHidden).disposed(by: disposeBag)

        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) {
            (index, album: AlbumModel, cell) in
            let cell = cell as? AlbumViewCell
            cell?.configure(album)
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(AlbumModel.self)
            .subscribe(onNext:  { [weak self] album in
                if let strongSelf = self {
                    strongSelf.navigator?.toAlbumDetails(album)
                }
            })
            .disposed(by: disposeBag)
    }
}
