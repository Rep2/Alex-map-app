import CoreLocation
import RxSwift

enum LocationManagerError: Error, LocalizedError {
    case locationServicesNotAuthorizedByUser
    case locationServicesNotEnabled

    var errorDescription: String? {
        switch self {
        case .locationServicesNotEnabled:
            return "The location service is not enabled. Your device might not be able to collect location data."
        case .locationServicesNotAuthorizedByUser:
            return "The location service is not authorized. If you would like to use the app, enable the location service in the settings."
        }
    }
}

class LocationManager: NSObject {
    static let sharedInstance = LocationManager()

    private let clLocationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        return locationManager
    }()

    fileprivate lazy var authorizationStatusSubject = BehaviorSubject<CLAuthorizationStatus>(value: CLLocationManager.authorizationStatus())
    fileprivate lazy var locationSubject = BehaviorSubject<CLLocation?>(value: nil)
    fileprivate lazy var headingSubject = BehaviorSubject<CLHeading?>(value: nil)

    var authorizationStatusObservable: Observable<CLAuthorizationStatus> {
        return authorizationStatusSubject.asObservable()
    }

    private override init() {
        super.init()

        enableBasicLocationServices()
    }

    private func enableBasicLocationServices() {
        clLocationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            clLocationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func startReceivingLocationChanges() -> Observable<CLLocation?> {
//        if let error = checkAutorizationStatus() {
//            return .error(error)
//        }

        clLocationManager.startUpdatingLocation()

        return locationSubject.asObservable()
    }

    func startReceivingHeadingChanges() -> Observable<CLHeading?> {
//        if let error = checkAutorizationStatus() {
//            return .error(error)
//        }

        clLocationManager.startUpdatingHeading()

        return headingSubject.asObservable()
    }

    func checkAutorizationStatus() -> Error? {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            return LocationManagerError.locationServicesNotAuthorizedByUser
        }

        if !CLLocationManager.locationServicesEnabled() {
            return LocationManagerError.locationServicesNotEnabled
        }

        return nil
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.onNext(status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationSubject.onNext(locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingSubject.onNext(newHeading)
    }
}
