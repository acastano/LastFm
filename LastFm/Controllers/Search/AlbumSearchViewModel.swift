import RxSwift
import Foundation

struct AlbumSearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AlbumRepository
    private let searchText = Variable<String>("")
    private let tableHiddenVariable = Variable<Bool>(false)
    private let loadingHiddenVariable = Variable<Bool>(true)
    private let contentHiddenVariable = Variable<Bool>(false)
    private let contentTextVariable = Variable<String>(NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: ""))

    private let itemsVariable = Variable<[AlbumModel]>([])

    init(repository: AlbumRepository) {
        self.repository = repository
        fetchItems()
    }

    var items: Observable<[AlbumModel]> {
        return self.itemsVariable.asObservable()
    }

    var contentHidden: Observable<Bool> {
        return self.contentHiddenVariable.asObservable()
    }

    var contentText: Observable<String> {
        return self.contentTextVariable.asObservable()
    }

    var loadingHidden: Observable<Bool> {
        return self.loadingHiddenVariable.asObservable()
    }

    var tableHidden: Observable<Bool> {
        return self.tableHiddenVariable.asObservable()
    }

    func updateQuery(_ query: String) {
        searchText.value = query
    }

    private func fetchItems() {
        let observable = searchText
            .asObservable()
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[AlbumModel]> in
                let count = self.itemsVariable.value.count
                self.tableHiddenVariable.value = count == 0
                self.loadingHiddenVariable.value = count > 0 || query.count == 0
                self.contentHiddenVariable.value = count > 0 || !self.loadingHiddenVariable.value
                self.contentTextVariable.value = query.isEmpty ? NSLocalizedString("AlbumSearchViewControllerPlaceholder", comment: "") : NSLocalizedString("NoContentText", comment: "")
                return !query.isEmpty ? self.repository.search(query).catchErrorJustReturn([]) : Observable.just([])
        }.asObservable()

        observable.subscribe(onNext: { items  in
            self.itemsVariable.value = items
            self.loadingHiddenVariable.value = true
            self.tableHiddenVariable.value = items.count == 0
            self.contentHiddenVariable.value = items.count > 0
        }).disposed(by: disposeBag)
    }
}
