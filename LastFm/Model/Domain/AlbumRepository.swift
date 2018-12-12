import RxSwift
import Foundation

protocol AlbumRepository {
    func info(_ album: AlbumModel) -> Observable<AlbumInfo>
    func search(_ query: String) -> Observable<[AlbumModel]>
}
