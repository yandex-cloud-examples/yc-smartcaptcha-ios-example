import WebKit


final class WebContentController: UIViewController, WKNavigationDelegate, CaptchaWebContainerControllerProtocol {
    
    var contentHeight: CGFloat = 350.0
    
    private var onReadyLoadCaptcha: (() -> ())?
    private weak var webview: WKWebView?
    weak var keyboardHeightDelegate: SheetControllerKeyboardHeightDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeWebView()
    }
    
    func makeWebView() {
        guard let webview else { return }
        view.addSubview(webview)
        webview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: webview.topAnchor),
            view.leftAnchor.constraint(equalTo: webview.leftAnchor),
            view.heightAnchor.constraint(equalTo: webview.heightAnchor),
            view.widthAnchor.constraint(equalTo: webview.widthAnchor)
        ])
        onReadyLoadCaptcha?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupWebController(_ webview: WKWebView, onReady: @escaping () -> ()) {
        self.webview = webview
        onReadyLoadCaptcha = onReady
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        if let screenHeght = view.window?.bounds.height,
           (keyboardScreenEndFrame.origin.y >= screenHeght) {
            keyboardHeightDelegate?.keyboardHeightDidChange(0)
        } else {
            keyboardHeightDelegate?.keyboardHeightDidChange(keyboardScreenEndFrame.height)
        }
    }
}
