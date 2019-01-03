struct Search: Codable {
    let results: Results
}

struct Results: Codable {
    let albummatches: Albummatches
}

struct Albummatches: Codable {
    let album: [Album]
}

struct Album: Codable {
    let mbid: String
    let name, artist: String
    let image: [Image]
}

struct Image: Codable {
    let text: String
    let size: Size

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

enum Size: String, Codable {
    case extralarge
    case large
    case medium
    case small
    case mega
    case empty = ""
}
