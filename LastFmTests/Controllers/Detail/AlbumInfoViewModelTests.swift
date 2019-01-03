import XCTest
import RxSwift
import RxCocoa
import PaymentKit

final class AlbumInfoViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    private let paymentKit = PaymentKit.sharedInstance

    func testMakePayment() {
        let album = AlbumModel(id: "1", artistText: "", albumText: "albumText", image: nil, placeholderImage:"")

        let viewModel = AlbumInfoViewModel(repository: AlbumRepositorySuccessImpl(), albumModel: album, paymentKit: PaymentKit.sharedInstance)

        var loadingHidden = false
        viewModel.makePayment(album.id, productDescription: album.albumText, value: "1")
        viewModel.loadingHidden.subscribe(onNext: { loading in
            loadingHidden = loading
        }).disposed(by: disposeBag)
        XCTAssert(loadingHidden == false)

        let expectation = XCTestExpectation(description: "Fail payment")

        var paymentSuccess = false
        viewModel.paymentSuccess.subscribe(onNext: { success in
            paymentSuccess = success
            expectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.6)
        XCTAssert(paymentSuccess)
    }

    func testCancelPayment() {
        let album = AlbumModel(id: "1", artistText: "", albumText: "albumText", image: nil, placeholderImage:"")

        let viewModel = AlbumInfoViewModel(repository: AlbumRepositorySuccessImpl(), albumModel: album, paymentKit: PaymentKit.sharedInstance)

        let expectation = XCTestExpectation(description: "Fail payment")

        viewModel.makePayment(album.id, productDescription: album.albumText, value: "1")
        viewModel.paymentSuccess.subscribe(onNext: { success in
            expectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.6)

        var loadingHidden = false
        viewModel.cancelPayment()
        viewModel.loadingHidden.subscribe(onNext: { loading in
            loadingHidden = loading
        }).disposed(by: disposeBag)
        XCTAssert(loadingHidden == false)

        let cancelExpectation = XCTestExpectation(description: "Fail payment")

        var cancelSuccess = false
        viewModel.cancelPaymentSuccess.subscribe(onNext: { success in
            cancelSuccess = success
            cancelExpectation.fulfill()
        }).disposed(by: disposeBag)

        wait(for: [cancelExpectation], timeout: 1.6)
        XCTAssert(cancelSuccess)
    }

    override func tearDown() {
        paymentKit.clear()
        super.tearDown()
    }
}
