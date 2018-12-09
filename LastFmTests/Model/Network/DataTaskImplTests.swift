import XCTest
import RxSwift

final class DataTaskImplTests: XCTestCase {
    private let disposeBag = DisposeBag()

    func testDataTaskWrongProtocol() {
        let task = DataTaskImpl(baseURL: "protocol://url.com")

        let expectation = XCTestExpectation(description: "Fail call")
        var success = false

        let resource = Resource(parameters: "example", method: .get)

        let observable: Observable<Album> = task.loadData(resource)
            observable.observeOn(MainScheduler.instance)
            .subscribe(onError: { any in
                success = true
                expectation.fulfill()
            }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(success)
    }

    func testDataTaskInvalidBaseURL() {
        let task = DataTaskImpl(baseURL: "")

        let expectation = XCTestExpectation(description: "Fail call")
        var success = false

        let resource = Resource(parameters: "example", method: .get)

        let observable: Observable<Album> = task.loadData(resource)
        observable.observeOn(MainScheduler.instance)
            .subscribe(onError: { any in
                success = true
                expectation.fulfill()
            }).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertTrue(success)
    }
}
