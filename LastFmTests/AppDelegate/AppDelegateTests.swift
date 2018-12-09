import XCTest

final class AppDelegateTests: XCTestCase {
    func testAppDelegateSetControllerAsRoot() {
        let appDelegate = AppDelegate()
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)

        let navigationController = appDelegate.window?.rootViewController as? UINavigationController

        XCTAssertTrue(navigationController != nil)
        XCTAssertTrue(navigationController?.viewControllers.first is AlbumSearchViewController)
    }
}

