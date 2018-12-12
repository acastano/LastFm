import RxSwift
import Foundation

struct AlbumInfoViewModel {
    private let disposeBag = DisposeBag()

    let albumModel: AlbumModel
    
    private let repository: AlbumRepository
    private let loadingHiddenVariable = Variable<Bool>(false)
    private let loadingLabelTextVariable = Variable<String>(NSLocalizedString("LoadingText", comment: ""))

    private let itemsVariable = Variable<[TrackModel]>([])

    init(repository: AlbumRepository, albumModel: AlbumModel) {
        self.albumModel = albumModel
        self.repository = repository
        fetchItems()
    }

    var items: Observable<[TrackModel]> {
        return self.itemsVariable.asObservable()
    }

    var loadingHidden: Observable<Bool> {
        return self.loadingHiddenVariable.asObservable()
    }

    var loadingLabelText: Observable<String> {
        return self.loadingLabelTextVariable.asObservable()
    }

    private func fetchItems() {

        repository.info(albumModel)
            .subscribe(onNext: { albumInfo in
                self.itemsVariable.value = albumInfo.album.tracks.track.map(TrackModel.init)
                self.loadingHiddenVariable.value = albumInfo.album.tracks.track.count > 0
                self.loadingLabelTextVariable.value = NSLocalizedString("NoContentText", comment: "")
            }, onError: { error in
                self.loadingLabelTextVariable.value = NSLocalizedString("NoContentText", comment: "")
            }).disposed(by: disposeBag)
    }
}
