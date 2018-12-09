import UIKit

final class AlbumTrackViewCell: UICollectionViewCell {

    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    func configure(_ viewModel: TrackViewModel) {
        trackLabel.text = viewModel.nameText
        durationLabel.text = viewModel.durationText
    }
}
