import Foundation

struct AlbumRepositoryFactory {
    static func album() -> AlbumRepository {
        let albumRepository = AlbumRepositoryImpl(dataTask: DataTaskImpl(baseURL: baseURLString))
        return albumRepository
    }
}
