import RxSwift
import Foundation

final class DataTaskSuccess: NSObject, DataTask {
    private var fileName: String?

    convenience init(fileName: String) {
        self.init()
        self.fileName = fileName
    }

    func loadData<T: Decodable>(_ resource: Resource) -> Observable<T> {
        return Observable<T>.create { observer in
            var response: T?
            if let file = self.fileName, let data = self.dataFromJSONFile(file, bundle: Bundle(for: type(of: self))) {
                let decoder = JSONDecoder()
                response = try? decoder.decode(T.self, from: data)
            }

            if let response = response {
                observer.onNext(response)
            } else {
                observer.onError(NSError(domain: "", code: 0, userInfo: nil))
            }
            return Disposables.create {}
        }
    }
}
