import UIKit

class RootPageViewController: UIPageViewController {
    let controllers = [
        ColorViewController(color: #colorLiteral(red: 0.2, green: 0.8196078431, blue: 1, alpha: 1)),
        MapViewController(),
        ColorViewController(color: #colorLiteral(red: 0.2, green: 1, blue: 0.3176470588, alpha: 1))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

        setViewControllers(
            [controllers[1]],
            direction: .forward,
            animated: false,
            completion: nil
        )
    }
}

extension RootPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return neighbourViewController(of: viewController, offset: -1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return neighbourViewController(of: viewController, offset: 1)
    }

    func neighbourViewController(of viewController: UIViewController, offset: Int) -> UIViewController? {
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }

        let neighbourViewControllerIndex = viewControllerIndex + offset

        guard  neighbourViewControllerIndex >= 0 && neighbourViewControllerIndex < controllers.count else {
            return nil
        }

        return controllers[neighbourViewControllerIndex]
    }
}
