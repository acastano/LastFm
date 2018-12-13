import XCTest

final class NavigatorTests: XCTestCase {

    func testExample() {
        let controller = UINavigationController()
        let navigator = Navigator(navigationController: controller, repository: AlbumRepositoryFakeImpl())

        let album = AlbumModel(id: "", artistText: "", albumText: "", image: nil, placeholderImage:"")
        navigator.toAlbumDetails(album)

        XCTAssert(controller.viewControllers.first is AlbumInfoViewController)
    }
}
