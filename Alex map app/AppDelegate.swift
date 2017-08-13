import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        window?.rootViewController = RootTabBarViewCotroller(nibName: nil, bundle: nil)

        //RootPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        window?.makeKeyAndVisible()

        return true
    }
}
