import UIKit
import WebKit

protocol CaptchaWebContainerControllerProtocol: AnyObject {
    func setupWebController(_ webview: WKWebView, onReady: @escaping ()->())
}

protocol SheetControllerKeyboardHeightDelegate: AnyObject {
    func keyboardHeightDidChange(_ height: CGFloat)
}


final class CaptchaWebContainer: NSObject, WKNavigationDelegate, WebCaptchaMessageHandlerDelegate {
    static let defaultSheetHeight: CGFloat = 350.0
    
    var sheetHeight: CGFloat = defaultSheetHeight

    private var userContentController = WKUserContentController()
    private var handler: WebCaptchaMessageHandler
    private let webURL: URL

    private(set) var isActive: Bool = false
    private(set) var view: WKWebView?
    private(set) weak var delegate: CaptchaWebContainerDelegate?
    
    
    init(captchaURL: URL,
          validationURL: URL,
          secretKey: String,
          delegate: CaptchaWebContainerDelegate?) {
        
        webURL = captchaURL
        handler = WebCaptchaMessageHandler(name: "NativeClient",
                                           validator: Validator(url: validationURL, secret: secretKey))
        super.init()
        self.delegate = delegate
        handler.delegate = self
        userContentController.add(handler, name: handler.handlerName)
        setup()
    }
    
    func startInvisibleCaptcha(_ addToView: @escaping (WKWebView) -> ()) {
        guard let view else { return }
        addToView(view)
        startRequest()
    }

    func startCaptcha(_ controller: CaptchaWebContainerControllerProtocol) {
        guard let view else { return }
        view.removeFromSuperview()
        controller.setupWebController(view) { [weak self] in
            self?.startRequest()
        }
    }

    func reloadWebView() {
        view?.reload()
    }
    
    func startRequest() {
        if (!isActive) {
            view?.load(URLRequest(url: webURL))
            isActive = true
        }
    }

    func setup() {
        view = WKWebView(frame: .zero, configuration: getConfiguration())
        view?.navigationDelegate = self
    }

    private func closeIfNeed() {
        view?.removeFromSuperview()
        view = nil
        isActive = false
        setup()
    }

    private func getConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        return configuration
    }
    
    // WebCaptchaMessageHandlerDelegate
    
    func onSuccess() {
        delegate?.finishWithSuccess()
        closeIfNeed()
    }
    
    func onError(_ err: Error) {
        delegate?.finishWithError(err)
        closeIfNeed()
    }
    
    func onHide() {
        reloadWebView()
    }
    
    func onShow() {
        delegate?.needToShowCaptcha()
    }
    
    func changeContentSize(_ size: CGSize) {
        sheetHeight = size.height
        delegate?.changeWebContentSize(size)
    }
}
