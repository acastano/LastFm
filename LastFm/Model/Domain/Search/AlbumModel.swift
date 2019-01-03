import Foundation

struct AlbumModel {
    let id: String
    let artistText: String
    let albumText: String
    let image: String?
    let placeholderImage: String?

    init(album: Album) {
        id = album.artist
        artistText = album.artist
        albumText = album.name
        image = album.image.last?.text
        placeholderImage = "music-placeholder"
    }

    init(id: String, artistText: String, albumText: String, image: String?, placeholderImage: String?) {
        self.id = id
        self.artistText = artistText
        self.albumText = albumText
        self.image = image
        self.placeholderImage = placeholderImage
    }
}
