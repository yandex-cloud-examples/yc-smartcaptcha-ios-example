import UIKit

final class StartViewController: UIViewController {
    
    var container: CaptchaWebContainer?
    var isInvisibleCaptcha: Bool = true
    var isSheetCaptchaMode: Bool = true
    var sheetTransition = SheetTransition()
    
    func setupController(captchaURL: URL, validationURL: URL, secretKey: String) {
        container = CaptchaWebContainer(captchaURL: captchaURL,
                                        validationURL: validationURL,
                                        secretKey: secretKey,
                                        delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let btn = makeOpenCaptchaScreenBtn()
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: btn.centerYAnchor)
        ])
        btn.sizeToFit()
    }
    
    
    @objc func startCaptchaFlow() {
        if (isInvisibleCaptcha) {
            container?.startInvisibleCaptcha({ UIApplication.shared.windows.first?.addSubview($0) })
        } else {
            let controller = makeWebController()
            container?.startCaptcha(controller)
            present(controller, animated: true)
        }
    }
    
    func makeWebController() -> WebContentController {
        let controller = WebContentController()
        if (isSheetCaptchaMode) {
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = sheetTransition
            controller.keyboardHeightDelegate = self
        }
        return controller
    }
    
    private func makeOpenCaptchaScreenBtn() -> UIButton {
            let btn = UIButton(frame: .zero)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.backgroundColor = .systemBackground
            btn.setTitleColor(.darkText, for: .normal)
            btn.addTarget(self, action: #selector(startCaptchaFlow), for: .touchUpInside)
            btn.setTitle("Go to protected resource", for: .normal)
            return btn
        }
}

extension StartViewController: CaptchaWebContainerDelegate {
    func finishWithSuccess() {
        closeIfNeeded() {
            self.present(ProtectedController(), animated: true)
        }
        
    }
    
    func finishWithError(_ err: Error) {
        closeIfNeeded()
    }
    
    func needToShowCaptcha() {
        if (isInvisibleCaptcha) {
            let controller = makeWebController()
            container?.startCaptcha(controller)
            present(controller, animated: true)
        }
    }
    
    func changeWebContentSize(_ size: CGSize) {
        if let controller = (presentedViewController?.presentationController as? SheetPresentationController) {
            controller.sheetHeight = size.height
        }
    }
    
    func closeIfNeeded(_ afterCloseCallback: (() -> ())? = nil) {
        if let presented = presentedViewController {
            presented.dismiss(animated: true) {
                afterCloseCallback?()
            }
        } else {
            afterCloseCallback?()
        }
    }
}

extension StartViewController: SheetControllerKeyboardHeightDelegate {
    func keyboardHeightDidChange(_ height: CGFloat) {
        if let controller = (presentedViewController?.presentationController as? SheetPresentationController) {
            controller.keyboardOffset = height
        }
    }
}
