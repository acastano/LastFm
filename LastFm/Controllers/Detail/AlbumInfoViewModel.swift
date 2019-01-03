import RxSwift
import Foundation
import PaymentKit
import UIKit

struct AlbumInfoViewModel {
    private let disposeBag = DisposeBag()

    let albumModel: AlbumModel

    private let paymentKit: PaymentKit
    private let repository: AlbumRepository
    private let makePaymentSubject = PublishSubject<Bool>()
    private let cancelPaymentSubject = PublishSubject<Bool>()
    private let paymentHiddenVariable = Variable<Bool>(true)
    private let loadingHiddenVariable = Variable<Bool>(false)
    private let cancelPurchaseHiddenVariable = Variable<Bool>(true)
    private let loadingLabelTextVariable = Variable<String>(NSLocalizedString("LoadingText", comment: ""))

    private let itemsVariable = Variable<[TrackModel]>([])

    init(repository: AlbumRepository, albumModel: AlbumModel, paymentKit: PaymentKit) {
        self.paymentKit = paymentKit
        self.albumModel = albumModel
        self.repository = repository
        fetchItems()
    }

    var items: Observable<[TrackModel]> {
        return itemsVariable.asObservable()
    }

    var loadingHidden: Observable<Bool> {
        return loadingHiddenVariable.asObservable()
    }

    var loadingLabelText: Observable<String> {
        return loadingLabelTextVariable.asObservable()
    }

    var paymentSuccess: Observable<Bool> {
        return makePaymentSubject.asObservable()
    }

    var cancelPaymentSuccess: Observable<Bool> {
        return cancelPaymentSubject.asObservable()
    }

    var paymentButtonHidden: Observable<Bool> {
        return paymentHiddenVariable.asObservable()
    }

    var cancelPurchaseHidden: Observable<Bool>  {
        return cancelPurchaseHiddenVariable.asObservable()
    }
    
    func makePayment(_ productId: String, productDescription: String, value: String) {
        loadingHiddenVariable.value = false
        loadingLabelTextVariable.value = NSLocalizedString("ProcessingPaymentText", comment: "")

        UIApplication.shared.beginIgnoringInteractionEvents()
        paymentKit.makePayment(productId, description: productDescription, value: value) { result in

            self.makePaymentSubject.onNext(true)
            self.updatePaymentButtons()

            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

    func cancelPayment() {
        if let payment = paymentKit.payment(albumModel.id) {
            loadingHiddenVariable.value = false
            loadingLabelTextVariable.value = NSLocalizedString("CancellingPaymentText", comment: "")

            UIApplication.shared.beginIgnoringInteractionEvents()
            paymentKit.cancelPayment(payment.id) { result in

                self.cancelPaymentSubject.onNext(true)
                self.updatePaymentButtons()

                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }

    private func fetchItems() {

        repository.info(albumModel).subscribe(onNext: { albumInfo in
            self.updateSuccess(albumInfo)
        }, onError: { error in
            self.updateError()
        }).disposed(by: disposeBag)
    }

    private func updateSuccess(_ albumInfo: AlbumInfo) {
        let count = albumInfo.album.tracks.track.count
        itemsVariable.value = albumInfo.album.tracks.track.map(TrackModel.init)
        loadingHiddenVariable.value = count > 0

        let purchased = paymentKit.purchased(albumModel.id)
        paymentHiddenVariable.value = albumInfo.album.mbid.isEmpty || count == 0 || purchased
        cancelPurchaseHiddenVariable.value = !purchased
        loadingLabelTextVariable.value = NSLocalizedString("NoContentText", comment: "")
    }

    private func updateError() {
        paymentHiddenVariable.value = true
        cancelPurchaseHiddenVariable.value = true
        loadingLabelTextVariable.value = NSLocalizedString("NoContentText", comment: "")
    }

    private func updatePaymentButtons() {
        loadingHiddenVariable.value = true
        let purchased = paymentKit.purchased(albumModel.id)
        paymentHiddenVariable.value = purchased
        cancelPurchaseHiddenVariable.value = !purchased
    }
}
