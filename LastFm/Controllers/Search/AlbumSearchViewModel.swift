import RxSwift
import Foundation

struct AlbumSearchViewModel {
    private let disposeBag = DisposeBag()
    private let repository: AlbumRepository
    private let searchText = Variable<String>("")
    private let tableHiddenVariable = Variable<Bool>(false)
    private let loadingHiddenVariable = Variable<Bool>(true)
    private let noContentHiddenVariable = Variable<Bool>(false)

    private let itemsVariable = Variable<[AlbumModel]>([])

    init(repository: AlbumRepository) {
        self.repository = repository
        fetchItems()
    }

    var items: Observable<[AlbumModel]> {
        return self.itemsVariable.asObservable()
    }

    var noContentHidden: Observable<Bool> {
        return self.noContentHiddenVariable.asObservable()
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
                self.noContentHiddenVariable.value = count > 0 || !self.loadingHiddenVariable.value
                return !query.isEmpty ? self.repository.search(query).catchErrorJustReturn([]) : Observable.just([])
        }.asObservable()

        observable.subscribe(onNext: { items  in
            self.itemsVariable.value = items
            self.loadingHiddenVariable.value = true
            self.tableHiddenVariable.value = items.count == 0
            self.noContentHiddenVariable.value = items.count > 0
        }).disposed(by: disposeBag)
    }
}
