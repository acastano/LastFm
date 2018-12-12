import RxSwift
import Foundation

struct AlbumRepositoryFailureImpl: AlbumRepository {
    func info(_ album: AlbumModel) -> Observable<AlbumInfo> {
        return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
    }

    func search(_ query: String) -> Observable<[AlbumModel]> {
        return Observable.error(NSError(domain: "", code: 0, userInfo: nil))
    }
}
