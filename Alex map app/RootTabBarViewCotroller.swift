import UIKit

class RootTabBarViewCotroller: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollViewControllerWithPaging = ScrollViewControllerWithPaging(nibName: nil, bundle: nil)
        scrollViewControllerWithPaging.tabBarItem.title = "1"

        let scrollViewControllerWithPagingAndGestureRecognizers = ScrollViewControllerWithPaging2(nibName: nil, bundle: nil)
        scrollViewControllerWithPagingAndGestureRecognizers.tabBarItem.title = "2"

        viewControllers = [
            scrollViewControllerWithPaging,
            scrollViewControllerWithPagingAndGestureRecognizers
        ]
    }
}
