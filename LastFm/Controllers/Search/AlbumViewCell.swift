import UIKit
import ImageCache

final class AlbumViewCell: UITableViewCell {

    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumImageView: NetworkImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        albumImageView.layer.cornerRadius = 10
    }

    func configure(_ viewModel: AlbumViewModel) {
        albumLabel.text = viewModel.albumText
        artistLabel.text = viewModel.artistText
        albumImageView.loadImage(with: viewModel.image, placeholder: viewModel.placeholderImage)
    }
}