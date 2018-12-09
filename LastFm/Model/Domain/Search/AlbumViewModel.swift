import Foundation

struct AlbumViewModel {
    let artistText: String
    let albumText: String
    let image: String?
    let placeholderImage: String?

    init(album: Album) {
        artistText = album.artist
        albumText = album.name
        image = album.image.last?.text
        placeholderImage = "music-placeholder"
    }

    init(artistText: String, albumText: String, image: String?, placeholderImage: String?) {
        self.artistText = artistText
        self.albumText = albumText
        self.image = image
        self.placeholderImage = placeholderImage
    }
}
