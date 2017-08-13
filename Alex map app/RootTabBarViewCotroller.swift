import UIKit

class RootTabBarViewCotroller: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollViewControllerWithPaging = ScrollViewControllerWithPaging(nibName: nil, bundle: nil)
        scrollViewControllerWithPaging.tabBarItem.image = #imageLiteral(resourceName: "plus")

        let scrollViewControllerWithPagingAndGestureRecognizers = ScrollViewControllerWithPaging2(nibName: nil, bundle: nil)
        scrollViewControllerWithPagingAndGestureRecognizers.tabBarItem.image = #imageLiteral(resourceName: "plus")

        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.tabBarItem.image = #imageLiteral(resourceName: "plus")

        viewControllers = [
            scrollViewControllerWithPagingAndGestureRecognizers,
            scrollViewControllerWithPaging,
            pageViewController
        ]
    }
}
