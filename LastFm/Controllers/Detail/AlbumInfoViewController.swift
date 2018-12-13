import UIKit
import RxSwift
import ImageCache
import WorldPayKit

final class AlbumInfoViewController: UIViewController {
    static func controller(repository: AlbumRepository, wordPay: WorldPay = WorldPay.sharedInstance, album: AlbumModel) -> AlbumInfoViewController? {
        let controller = UIStoryboard.instantiateViewController(className(), anyClass: self) as? AlbumInfoViewController
        controller?.viewModel = AlbumInfoViewModel(repository: repository, albumModel: album, wordPay: wordPay)
        return controller
    }

    private let cellIdentifier = "cell"
    private let disposeBag = DisposeBag()

    private var topHeight = CGFloat(0.0)
    private var navigationHeight = CGFloat(0.0)
    private var viewModel: AlbumInfoViewModel?

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var cancelPaymentButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var albumImageView: NetworkImageView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topHeight = topViewHeightConstraint.constant
    }

    private func setup() {
        setupViews()
        setupObservables()
    }

    private func setupObservables() {
        viewModel?.items.bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier)) {
            (index, track: TrackModel, cell) in
            let cell = cell as? AlbumTrackViewCell
            cell?.configure(track)
            }
            .disposed(by: disposeBag)

        viewModel?.loadingLabelText.bind(to: loadingLabel.rx.text).disposed(by: disposeBag)
        viewModel?.loadingHidden.bind(to: loadingLabel.rx.isHidden).disposed(by: disposeBag)

        viewModel?.paymentButtonHidden.bind(to: payButton.rx.isHidden).disposed(by: disposeBag)
        viewModel?.cancelPurchaseHidden.bind(to: cancelPaymentButton.rx.isHidden).disposed(by: disposeBag)

        viewModel?.paymentSuccess
            .subscribe(onNext: { [weak self] success in
                self?.showPaymentSuccess()
            })
            .disposed(by: disposeBag)

        viewModel?.cancelPaymentSuccess
            .subscribe(onNext: { [weak self] success in
                self?.showCancelPaymentSuccess()
            })
            .disposed(by: disposeBag)

        payButton.rx.tap.subscribe(onNext: { [weak self] success in
            self?.processPayTap()
        })
            .disposed(by: disposeBag)

        cancelPaymentButton.rx.tap.subscribe(onNext: { [weak self] success in
            self?.processCancelPaymentTap()
        })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        title = viewModel?.albumModel.albumText

        payButton.layer.cornerRadius = 5
        payButton.setTitle(NSLocalizedString("AlbumInfoViewControllerBuyAlbum", comment: ""), for: .normal)

        cancelPaymentButton.layer.cornerRadius = 5
        cancelPaymentButton.setTitle(NSLocalizedString("AlbumInfoViewControllerCancelPayment", comment: ""), for: .normal)

        artistLabel.text = viewModel?.albumModel.artistText

        albumImageView.layer.cornerRadius = 10
        albumImageView.loadImage(with: viewModel?.albumModel.image, placeholder: viewModel?.albumModel.placeholderImage)
    }

    private func processPayTap() {
        if let albumModel = viewModel?.albumModel {
            viewModel?.makePayment(albumModel.id, productDescription: albumModel.albumText, value: "10.00")
        }
    }

    private func processCancelPaymentTap() {
        viewModel?.cancelPayment()
    }

    private func showPaymentSuccess() {
        let alertController = UIAlertController(title: NSLocalizedString("InfoText", comment: ""), message: NSLocalizedString("AlbumInfoViewControllerPaymentSuccessful", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OKText", comment: ""), style: . default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    private func showCancelPaymentSuccess() {
        let alertController = UIAlertController(title: NSLocalizedString("InfoText", comment: ""), message: NSLocalizedString("AlbumInfoViewControllerPaymentCancelled", comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OKText", comment: ""), style: . default, handler: nil))

        present(alertController, animated: true, completion: nil)
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
