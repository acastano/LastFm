import XCTest

final class TrackViewModelTests: XCTestCase {

    func testFailedTrackDuration() {
        let track = Track(name: "", duration: "")
        let viewModel = TrackViewModel(track: track)

        XCTAssert(viewModel.durationText == "TrackViewModelDuration 0:00")
    }
}
