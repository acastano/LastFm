import RxSwift
import Foundation

struct AlbumRepositoryImpl: AlbumRepository {
    private let dataTask: DataTask

    init (dataTask: DataTask) {
        self.dataTask = dataTask
    }

    func search(_ query: String) -> Observable<[AlbumViewModel]> {
        let resource = Resource(parameters: "method=album.search&album=\(query)", method: .get)

        let observable: Observable<Search> = dataTask.loadData(resource)
        return observable.map {
            $0.results.albummatches.album.map(AlbumViewModel.init)
        }
    }

    func info(_ album: AlbumViewModel) -> Observable<AlbumInfo> {
        let resource = Resource(parameters: "method=album.getinfo&artist=\(album.artistText)&album=\(album.albumText)", method: .get)

        let observable: Observable<AlbumInfo> = dataTask.loadData(resource)
        return observable
    }
}
