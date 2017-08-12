import UIKit
import MapKit
import SnapKit
import RxSwift

class MapViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.delegate = self

        return map
    }()

    var didSetLocation = false

    lazy var headingView: UIView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Image"))
        view.frame = CGRect(x: -3, y: -3, width: 50, height: 50)
        view.tintColor = .green

        return view
    }()

    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startReceivingLocationChanges()

        setupViewController()

        setupSubvews()

        startReceivingHeadingChanges()
    }

    func setupViewController() {
        title = "Map"
    }

    func setupSubvews() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }

    func startReceivingLocationChanges() {
        LocationManager
            .sharedInstance
            .startReceivingLocationChanges()
            .subscribe(
                onNext: { [weak self] location in
                    if let strongSelf = self, let location = location, !strongSelf.didSetLocation {
                        strongSelf.mapView.setCenter(location.coordinate, animated: false)

                        strongSelf.didSetLocation = true
                    }
                },
                onError: { [weak self] error in
                    if let strongSelf = self, let error = error as? LocalizedError {
                        error.displayAsAlert(title: "An error occurred while accessing location service", viewController: strongSelf)
                    }
                }
            ).addDisposableTo(disposeBag)
    }

    func startReceivingHeadingChanges() {
        LocationManager
            .sharedInstance
            .startReceivingHeadingChanges()
            .subscribe(
                onNext: { [weak self] heading in
                    if let strongSelf = self, let heading = heading, heading.headingAccuracy > 0 {
                        let direction = heading.trueHeading > 0 ? heading.trueHeading : heading.magneticHeading

                        strongSelf.updateHeadingViewAngle(direction: direction)
                    }
            },
                onError: { [weak self] error in
                    if let strongSelf = self, let error = error as? LocalizedError {
                        error.displayAsAlert(title: "An error occurred while accessing location service", viewController: strongSelf)
                    }
                }
            ).addDisposableTo(disposeBag)
    }

    func updateHeadingViewAngle(direction: CLLocationDirection) {
        headingView.transform = CGAffineTransform(rotationAngle: CGFloat(direction * Double.pi / 180))
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocationView = views.filter({ $0.annotation is MKUserLocation }).last {
            userLocationView.insertSubview(headingView, at: 0)
        }
    }
}
