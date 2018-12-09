
import RxSwift
import RxCocoa
import Foundation

struct DataTaskImpl: DataTask {
    private let baseURL: String
    private let decoder = JSONDecoder()

    init (baseURL: String) {
        self.baseURL = baseURL
    }

    func loadData<T: Decodable>(_ resource: Resource) -> Observable<T> {
        guard let url = resource.url(baseURL) else { return Observable<T>.error(NSError(domain: "network", code: 0, userInfo: nil)) }

        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue

        return URLSession.shared.rx.response(request: request).map { (_, jsonData) -> T in
            return try self.decoder.decode(T.self, from: jsonData)
        }
    }
}
