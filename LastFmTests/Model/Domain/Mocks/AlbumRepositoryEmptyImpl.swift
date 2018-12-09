import RxSwift
import Foundation

struct AlbumRepositoryEmptyImpl: AlbumRepository {
    func info(_ album: AlbumViewModel) -> Observable<AlbumInfo> {
        return Observable.empty()
    }

    func search(_ query: String) -> Observable<[AlbumViewModel]> {
        return Observable.empty()
    }
}
