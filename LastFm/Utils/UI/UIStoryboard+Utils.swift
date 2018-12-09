import UIKit

extension UIStoryboard {
    
    static func instantiateViewController(_ name:String, anyClass:AnyClass) -> UIViewController? {
        let bundle = Bundle(for:anyClass)
        
        let storyboard = UIStoryboard(name:name, bundle:bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: name)
        return controller
    }
}
