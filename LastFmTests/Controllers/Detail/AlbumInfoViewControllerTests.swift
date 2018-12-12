import XCTest
import RxSwift
import RxCocoa

final class AlbumInfoViewControllerTests: XCTestCase {

    private var controller: AlbumInfoViewController?

    func testOutletsAreAssigned() {
        let repository = AlbumRepositoryFakeImpl()
        let album = AlbumModel(artistText: "", albumText: "", image: nil, placeholderImage:"")

        controller = AlbumInfoViewController.controller(repository: repository, album: album)
        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.artistLabel != nil)
        XCTAssertTrue(controller?.loadingLabel != nil)
        XCTAssertTrue(controller?.collectionView != nil)
        XCTAssertTrue(controller?.albumImageView != nil)
        XCTAssertTrue(controller?.topViewTopConstraint != nil)
        XCTAssertTrue(controller?.topViewTopConstraint != nil)
        XCTAssertTrue(controller?.topViewHeightConstraint != nil)
    }

    func testSetup() {
        let repository = AlbumRepositorySuccessImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)
        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.title == "albumText")
        XCTAssertTrue(controller?.artistLabel.text == "artistText")
    }

    func testTopHeightOnScrollOffsetZero() {
        let repository = AlbumRepositorySuccessImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)
        controller?.view.layoutIfNeeded()

        controller?.viewWillAppear(false)

        if let scrollView = controller?.collectionView {
            controller?.scrollViewDidScroll(scrollView)
            XCTAssertTrue(controller?.topViewTopConstraint.constant == 0)
            XCTAssertTrue(controller?.topViewHeightConstraint.constant == 233.5)
        } else {
            XCTFail()
        }
    }

    func testTopHeightOnScrollOffsetOneHundred() {
        let repository = AlbumRepositorySuccessImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)
        controller?.view.layoutIfNeeded()

        controller?.viewWillAppear(false)

        if let scrollView = controller?.collectionView {
            scrollView.contentOffset = CGPoint(x: 0, y: 100)
            controller?.scrollViewDidScroll(scrollView)
            XCTAssertTrue(controller?.topViewTopConstraint.constant == -100)
            XCTAssertTrue(controller?.topViewHeightConstraint.constant == 233.5)
        } else {
            XCTFail()
        }
    }

    func testTopHeightOnScrollOffsetBiggerThanTopHeight() {
        let repository = AlbumRepositorySuccessImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)
        controller?.view.layoutIfNeeded()

        controller?.viewWillAppear(false)

        if let scrollView = controller?.collectionView {
            scrollView.contentOffset = CGPoint(x: 0, y: 1000)
            controller?.scrollViewDidScroll(scrollView)
            XCTAssertTrue(controller?.topViewTopConstraint.constant == -233.5)
            XCTAssertTrue(controller?.topViewHeightConstraint.constant == 233.5)
        } else {
            XCTFail()
        }
    }

    func testTrackLabelsAreSet() {
        let repository = AlbumRepositorySuccessImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)

        controller?.view.layoutIfNeeded()
        let cell = controller?.collectionView.cellForItem(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is AlbumTrackViewCell)
        let trackCell = cell as? AlbumTrackViewCell

        XCTAssertTrue(trackCell?.trackLabel.text == "Intro / El Nay A\'atini Nay")
        XCTAssertTrue(trackCell?.durationLabel.text == "TrackModelDuration 2:02")
    }

    func testLoadingLabelIsSet() {
        let repository = AlbumRepositoryFakeImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)

        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.title == "albumText")
        XCTAssertTrue(controller?.artistLabel.text == "artistText")
        XCTAssertTrue(controller?.loadingLabel.text == "LoadingText")
    }

    func testFailureLabelIsSet() {
        let repository = AlbumRepositoryFailureImpl()
        let album = AlbumModel(artistText: "artistText", albumText: "albumText", image: nil, placeholderImage: nil)

        controller = AlbumInfoViewController.controller(repository: repository, album: album)

        controller?.view.layoutIfNeeded()

        XCTAssertTrue(controller?.title == "albumText")
        XCTAssertTrue(controller?.artistLabel.text == "artistText")
        XCTAssertTrue(controller?.loadingLabel.text == "NoContentText")
    }
}
