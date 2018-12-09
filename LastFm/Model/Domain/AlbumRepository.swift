import RxSwift
import Foundation

protocol AlbumRepository {
    func info(_ album: AlbumViewModel) -> Observable<AlbumInfo>
    func search(_ query: String) -> Observable<[AlbumViewModel]>
}
