import WebKit

protocol WebCaptchaMessageHandlerDelegate: AnyObject {
    func onSuccess()
    func onError(_ err: Error)
    func onHide()
    func onShow()
    func changeContentSize(_ size: CGSize)
}

protocol CaptchaWebContainerDelegate: AnyObject {
    func finishWithSuccess()
    func finishWithError(_ err: Error)
    func needToShowCaptcha()
    func changeWebContentSize(_ size: CGSize)
}


final class WebCaptchaMessageHandler: NSObject, WKScriptMessageHandler {
    
    let handlerName: String
    let validator: ValidatorProtocol
    weak var delegate: WebCaptchaMessageHandlerDelegate?
    
    init(name: String, validator: ValidatorProtocol) {
        handlerName = name
        self.validator = validator
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let jsData = message.body as? [String: Any] else { return }
        guard let methodName = jsData["method"] as? String else { return }
        onMethod(methodName, data: jsData)
    }
    
    private func onMethod(_ method: String, data: [String: Any]) {
        changeCaptchaSizeIfNeeded(data: data["size"] as? [String: Int])
        switch method {
        case "captchaDidFinish":
            guard let token = data["data"] as? String else { return }
            onSuccess(token: token)
        case "challengeDidAppear":
            onChallengeDidAppear()
        case "challengeDidDisappear":
            onChallengeDidDisappear()
        default:
            return
        }
    }
    
    private func onSuccess(token: String) {
        validator.validateCaptcha(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.delegate?.onSuccess()
                case .failure(let err):
                    self.delegate?.onError(err)
                }
            }
        }
    }

    private func onChallengeDidAppear() {
        delegate?.onShow()
    }

    private func onChallengeDidDisappear() {
        delegate?.onHide()
    }
    
    private func changeCaptchaSizeIfNeeded(data: [String: Int]?) {
        guard let data,
              let width = data["width"],
              let height = data["height"]
        else { return }
        delegate?.changeContentSize(.init(width: width, height: height))
    }
}
