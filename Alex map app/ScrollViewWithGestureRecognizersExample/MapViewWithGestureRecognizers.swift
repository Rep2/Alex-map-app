import UIKit
import MapKit
import SnapKit
import RxSwift

class MapViewWithGestureRecognizers: MapView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(leftEdgePanGestureRecognizer)
        addGestureRecognizer(rightEdgePanGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var leftEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MapViewWithGestureRecognizers.didPan))
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.left

        return gestureRecognizer
    }()

    lazy var rightEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MapViewWithGestureRecognizers.didPan))
        gestureRecognizer.delegate = self
        gestureRecognizer.edges = UIRectEdge.right

        return gestureRecognizer
    }()

    var edgePanGestureRecognizerStartLocation: CGPoint?

    func didPan(edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch edgePanGestureRecognizer.state {
        case .began:
            edgePanGestureRecognizerStartLocation = edgePanGestureRecognizer.location(in: superview?.superview)
        case .changed:
            let xOffset = edgePanGestureRecognizer.location(in: superview?.superview).x - (edgePanGestureRecognizerStartLocation?.x ?? 0)

            ScrollViewControllerWithPaging2.sharedInstance?.scroll(offset: -xOffset)
        default:
            break
        }
    }
}

extension MapViewWithGestureRecognizers: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == leftEdgePanGestureRecognizer || gestureRecognizer == rightEdgePanGestureRecognizer {
            return true
        }

        return false
    }
}
