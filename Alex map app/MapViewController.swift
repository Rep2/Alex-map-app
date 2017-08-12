import UIKit
import MapKit
import SnapKit
import RxSwift

class MapViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true

        return map
    }()

    var didSetLocation = false

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
            .subscribe(onNext: { heading in
                print(heading)
            }, onError: { [weak self] error in
                if let strongSelf = self, let error = error as? LocalizedError {
                    error.displayAsAlert(title: "An error occurred while accessing location service", viewController: strongSelf)
                }
            }
        )
    }
}
