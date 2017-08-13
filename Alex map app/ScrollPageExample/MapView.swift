import UIKit
import MapKit
import SnapKit
import RxSwift

class MapView: MKMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        showsUserLocation = true
        delegate = self

        startReceivingLocationChanges()
        startReceivingHeadingChanges()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var didSetLocation = false

    lazy var headingView: UIView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "Image"))
        view.frame = CGRect(x: -3, y: -3, width: 50, height: 50)
        view.tintColor = .green

        return view
    }()

    let disposeBag = DisposeBag()

    func startReceivingLocationChanges() {
        LocationManager
            .sharedInstance
            .startReceivingLocationChanges()
            .subscribe(
                onNext: { [weak self] location in
                    if let strongSelf = self, let location = location, !strongSelf.didSetLocation {
                        strongSelf.setCenter(location.coordinate, animated: false)

                        strongSelf.didSetLocation = true
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
                }
            ).addDisposableTo(disposeBag)
    }

    func updateHeadingViewAngle(direction: CLLocationDirection) {
        headingView.transform = CGAffineTransform(rotationAngle: CGFloat(direction * Double.pi / 180))
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocationView = views.filter({ $0.annotation is MKUserLocation }).last {
            userLocationView.insertSubview(headingView, at: 0)
        }
    }
}
