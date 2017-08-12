import UIKit

class ColorViewController: UIViewController {
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
