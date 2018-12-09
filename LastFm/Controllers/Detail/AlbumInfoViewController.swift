import UIKit
import RxSwift
import ImageCache

final class AlbumInfoViewController: UIViewController {
    static func controller(repository: AlbumRepository?, album: AlbumViewModel) -> AlbumInfoViewController? {
        let controller = UIStoryboard.instantiateViewController(className(), anyClass: self) as? AlbumInfoViewController
        controller?.album = album
        controller?.repository = repository
        return controller
    }

    private let cellIdentifier = "cell"
    private let disposeBag = DisposeBag()

    private var topHeight = CGFloat(0.0)
    private var navigationHeight = CGFloat(0.0)
    private var album: AlbumViewModel?
    private var repository: AlbumRepository?

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var albumImageView: NetworkImageView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let album = album else { return }
        setup(album)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topHeight = topViewHeightConstraint.constant
    }

    private func setup(_ album: AlbumViewModel) {
        setupViews(album)
        setupObservables(album)
    }

    private func setupObservables(_ album: AlbumViewModel) {
        let albumInfoObservable = albumInfo(album)

        albumInfoObservable?.map { $0.album.tracks.track.map(TrackViewModel.init) }
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier)) {
                (index, track: TrackViewModel, cell) in
                let cell = cell as? AlbumTrackViewCell
                cell?.configure(track)
            }
            .disposed(by: disposeBag)

        albumInfoObservable?.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] albumInfo in
                if let strongSelf = self {
                    strongSelf.configure(albumInfo)
                }
                }, onError: { [weak self] _ in
                    if let strongSelf = self {
                        strongSelf.configureError()
                    }
            }).disposed(by: disposeBag)
    }

    private func setupViews(_ album: AlbumViewModel) {
        title = album.albumText
        artistLabel.text = album.artistText

        albumImageView.layer.cornerRadius = 10
        loadingLabel.text = NSLocalizedString("LoadingText", comment: "")
        albumImageView.loadImage(with: album.image, placeholder: album.placeholderImage)
    }

    private func configure(_ albumInfo: AlbumInfo) {
        loadingLabel.isHidden = albumInfo.album.tracks.track.count > 0
    }

    private func configureError() {
        loadingLabel.isHidden = false
        loadingLabel.text = NSLocalizedString("NoContentText", comment: "")
    }

    private func albumInfo(_ album: AlbumViewModel) -> Observable<AlbumInfo>? {
        return repository?.info(album)
    }
}

extension AlbumInfoViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        if offset <= 0 {
            topViewTopConstraint.constant = 0
            topViewHeightConstraint?.constant = topHeight - offset
        } else {
            let constant = min(offset , topHeight)

            topViewTopConstraint.constant = -constant
            topViewHeightConstraint?.constant = topHeight
        }
    }
}

extension AlbumInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let height = topHeight
        let size = CGSize(width: collectionView.frame.width, height: height)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}

