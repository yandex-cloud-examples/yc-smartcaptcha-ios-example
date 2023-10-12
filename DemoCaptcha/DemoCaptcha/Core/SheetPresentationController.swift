import Foundation
import UIKit

class SheetPresentationController: UIPresentationController {
    
    private static let defaultSheetHeight: CGFloat = 350.0
    
    private var summuryHeight: CGFloat = defaultSheetHeight {
        didSet {
            if oldValue != summuryHeight {
                self.containerViewDidLayoutSubviews()
            } 
        }
    }
    
    var keyboardOffset: CGFloat = 0 {
        didSet {
            summuryHeight = keyboardOffset + sheetHeight
        }
    }
    
    var sheetHeight: CGFloat = defaultSheetHeight {
        didSet {
            summuryHeight = keyboardOffset + sheetHeight
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let inset: CGFloat = 0.0
        let safeAreaFrame = containerView.bounds
                .inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width

        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y = frame.size.height - summuryHeight
        frame.size.width = targetWidth
        frame.size.height = summuryHeight
        return frame
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
