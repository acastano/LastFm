import RxSwift
import Foundation

struct AlbumRepositoryFailureImpl: AlbumRepository {
    func info(_ album: AlbumViewModel) -> Observable<AlbumInfo> {
        return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
    }

    func search(_ query: String) -> Observable<[AlbumViewModel]> {
        return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
    }
}
