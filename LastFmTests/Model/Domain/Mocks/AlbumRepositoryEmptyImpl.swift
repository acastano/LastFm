import RxSwift
import Foundation

struct AlbumRepositoryEmptyImpl: AlbumRepository {
    func info(_ album: AlbumModel) -> Observable<AlbumInfo> {
        return Observable.empty()
    }

    func search(_ query: String) -> Observable<[AlbumModel]> {
        return Observable.empty()
    }
}
