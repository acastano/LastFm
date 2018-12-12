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

    func configure(_ model: AlbumModel) {
        albumLabel.text = model.albumText
        artistLabel.text = model.artistText
        albumImageView.loadImage(with: model.image, placeholder: model.placeholderImage)
    }
}
