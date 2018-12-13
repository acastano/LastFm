import XCTest
import RxSwift
import RxCocoa

final class AlbumSearchViewControllerTests: XCTestCase {

    private var controller: AlbumSearchViewController?

    func testOutletsAreAssigned() {
        let repository = AlbumRepositoryFakeImpl()
        controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: UINavigationController(), repository: repository), keyboardManager: KeyboardManagerImpl())

        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.searchBar != nil)
        XCTAssertTrue(controller?.tableView != nil)
        XCTAssertTrue(controller?.contentLabel != nil)
    }

    func testSetup() {
        let repository = AlbumRepositoryEmptyImpl()
        controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: UINavigationController(), repository: repository), keyboardManager: KeyboardManagerImpl())
        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.tableView.isHidden == true)
        XCTAssertTrue(controller?.contentLabel.isHidden == false)
        XCTAssertTrue(controller?.title == "AlbumSearchViewControllerTitle")
        XCTAssertTrue(controller?.contentLabel.text == "AlbumSearchViewControllerPlaceholder")
        XCTAssertTrue(controller?.searchBar.placeholder == "AlbumSearchViewControllerPlaceholder")
    }

    func testAlbumLabelsAreSet() {
        let repository = AlbumRepositoryImpl(dataTask: DataTaskSuccess(fileName: "search.json"))
        controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: UINavigationController(), repository: repository), keyboardManager: KeyboardManagerImpl())

        controller?.view.layoutIfNeeded()

        controller?.viewModel?.updateQuery("query")

        let cell = controller?.tableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is AlbumViewCell)
        let albumCell = cell as? AlbumViewCell

        XCTAssertTrue(albumCell?.artistLabel.text == "Shakira")
        XCTAssertTrue(albumCell?.albumLabel.text == "Shakira. (Deluxe Version)")
    }

    func testLoadingIsSet() {
        let repository = AlbumRepositoryEmptyImpl()
        controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: UINavigationController(), repository: repository), keyboardManager: KeyboardManagerImpl())

        controller?.view.layoutIfNeeded()

        controller?.searchBar.text = "T"

        controller?.viewDidLoad()

        XCTAssertTrue(controller?.loadingLabel.text == "LoadingText")
    }

    func testNoContent() {
        let repository = AlbumRepositoryFakeImpl()
        controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: UINavigationController(), repository: repository), keyboardManager: KeyboardManagerImpl())

        controller?.view.layoutIfNeeded()

        controller?.searchBar.text = "T"

        controller?.viewDidLoad()

        XCTAssertTrue(controller?.tableView.isHidden == true)
        XCTAssertTrue(controller?.contentLabel.isHidden == false)
        XCTAssertTrue(controller?.contentLabel.text == "NoContentText")
    }
}
