import UIKit

final class AlbumTrackViewCell: UICollectionViewCell {

    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    func configure(_ model: TrackModel) {
        trackLabel.text = model.nameText
        durationLabel.text = model.durationText
    }
}
