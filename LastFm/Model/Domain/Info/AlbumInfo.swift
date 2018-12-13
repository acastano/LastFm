struct AlbumInfo: Codable {
    let album: AlbumDetail
}

struct AlbumDetail: Codable {
    let mbid: String
    let name: String
    let artist: String
    let tracks: Tracks
}

struct Tracks: Codable {
    let track: [Track]
}

struct Track: Codable {
    let name: String
    let duration: String

    init (name: String, duration: String) {
        self.name = name
        self.duration = duration
    }
}
