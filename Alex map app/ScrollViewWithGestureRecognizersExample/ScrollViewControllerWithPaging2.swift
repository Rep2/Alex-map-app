import UIKit

class ScrollViewControllerWithPaging2: UIViewController, UIScrollViewDelegate {
    static var sharedInstance: ScrollViewControllerWithPaging2?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height)
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width, y: 0), animated: false)
        scrollView.delegate = self

        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        ScrollViewControllerWithPaging2.sharedInstance = self

        self.view.addSubview(scrollView)

        for index in 0...2 {
            let frame = CGRect(x: self.scrollView.frame.size.width * CGFloat(index), y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

            let subView: UIView

            if index == 0 {
                subView = UIView(frame: frame)
                subView.backgroundColor = #colorLiteral(red: 0.2, green: 0.8196078431, blue: 1, alpha: 1)
            } else if index == 1 {
                subView = MapViewWithGestureRecognizers(frame: frame)
            } else {
                subView = UIView(frame: frame)
                subView.backgroundColor = #colorLiteral(red: 0.2, green: 1, blue: 0.3176470588, alpha: 1)
            }

             self.scrollView.addSubview(subView)
        }
    }

    func scroll(offset: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: self.view.bounds.width + offset, y: 0), animated: false)
    }
}
