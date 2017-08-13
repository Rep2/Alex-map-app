import UIKit
import MapKit
import SnapKit
import RxSwift

class MapViewWithGestureRecognizers: MapView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(panGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapViewWithGestureRecognizers.didPan))
        gestureRecognizer.delegate = self

        return gestureRecognizer
    }()

    func didPan() {
        print(panGestureRecognizer.location(in: self))
    }
}

extension MapViewWithGestureRecognizers: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
