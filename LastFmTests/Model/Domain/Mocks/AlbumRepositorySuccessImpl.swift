import RxSwift
import Foundation

final class AlbumRepositorySuccessImpl: NSObject, AlbumRepository {
    func info(_ album: AlbumViewModel) -> Observable<AlbumInfo> {

        var albumInfo: AlbumInfo?
        if let data = self.dataFromJSONFile("info.json", bundle: Bundle(for: type(of: self))) {
            let decoder = JSONDecoder()
            albumInfo = try? decoder.decode(AlbumInfo.self, from: data)
        }
        if let albumInfo = albumInfo {
            return Observable.just(albumInfo)
        } else {
            return Observable.empty()
        }
    }

    func search(_ query: String) -> Observable<[AlbumViewModel]> {
        let album = AlbumViewModel(artistText: "artistText", albumText: "albumText", image: "image", placeholderImage: "placeholderImage")

        return Observable.just([album])
    }
}
