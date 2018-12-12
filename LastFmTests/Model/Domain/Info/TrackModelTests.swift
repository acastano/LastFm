import XCTest

final class TrackModelTests: XCTestCase {

    func testFailedTrackDuration() {
        let track = Track(name: "", duration: "")
        let model = TrackModel(track: track)

        XCTAssert(model.durationText == "TrackModelDuration 0:00")
    }
}
