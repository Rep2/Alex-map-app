import UIKit

extension LocalizedError {
    func displayAsAlert(title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: errorDescription, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
}
