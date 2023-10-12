import Foundation
import UIKit

class SheetTransition: NSObject, UIViewControllerTransitioningDelegate {
    var sheetPresentationController: SheetPresentationController?
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SheetPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
