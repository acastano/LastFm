import Foundation

struct TrackModel {
    let nameText: String
    let durationText: String

    init(track: Track) {
        nameText = track.name
        let duration = Int(track.duration) ?? 0
        let (minutes, seconds) = TrackModel.secondsToMinutesSeconds(seconds: duration)
        durationText = NSLocalizedString("TrackModelDuration", comment: "") + " \(minutes):\(String(format: "%02d", seconds))"
    }

    private static func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
