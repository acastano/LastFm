import Foundation

extension NSObject {
    
    static func className() -> String {
        let name = String(describing: self)
        return name
    }

    func dataFromJSONFile(_ name: String, bundle: Bundle) -> Data? {
        let path = bundle.url(forResource: name, withExtension: nil)
        var data: Data?
        if let path = path {
            data = try? Data(contentsOf: path)
        }
        return  data
    }
}
        
