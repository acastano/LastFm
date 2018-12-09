import UIKit
import ImageCache

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application:UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = Window(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        let navigationController = UINavigationController()

        let repository = AlbumRepositoryFactory.album()
        if let controller = AlbumSearchViewController.controller(repository: repository, navigatior: Navigator(navigationController: navigationController, repository: repository)) {
            navigationController.viewControllers = [controller]
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        CacheUtils.clearAfterThirtyDays()
    }
}
