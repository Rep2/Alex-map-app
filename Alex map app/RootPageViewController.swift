import UIKit

class RootPageViewController: UIPageViewController {

    let controllers = [
        ColorViewController(color: .green),
        MapViewController(),
        ColorViewController(color: .blue)
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
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard controllers.count > previousIndex else {
            return nil
        }

        return controllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = controllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return controllers[nextIndex]
    }
}
