import UIKit
import MapKit

class MapViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)

        return map
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubvews()
    }

    func setupSubvews() {
        
    }
}