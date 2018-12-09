import RxSwift
import Foundation

final class DataTaskFailure: DataTask {
    private var calls = 0

    func loadData<T: Decodable>(_ resource: Resource) -> Observable<T> {
        let error = NSError(domain: "error", code: 1, userInfo: nil)
        
        let observable = Observable<T>.create { observer in
            observer.onError(error)
            return Disposables.create {}
        }
        return observable
    }
}
