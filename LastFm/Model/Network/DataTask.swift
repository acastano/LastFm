import RxSwift

protocol DataTask {
    func loadData<T: Decodable>(_ resource: Resource) -> Observable<T>
}
