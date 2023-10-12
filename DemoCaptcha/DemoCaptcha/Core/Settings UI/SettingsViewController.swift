import UIKit

let SECRET_KEY = ""
let SITE_KEY = ""

let CAPTCHA_WEBPAGE_URL = ""
let VALIDATION_SERVER_URL = ""

final class SettingsViewController: UIViewController, UITableViewDelegate {
    var tableView: UITableView?
    var settings: SettingsDataSource!
    var sections = [SectionModel]()
    
    var settingsModel = Settings(
            screenMode: .pixelSquared,
            captchaRecognize: .success
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        makeSettings()
        settings = SettingsDataSource(sections: sections, table: tableView)
        tableView?.delegate = self
        tableView?.dataSource = settings

        tableView?.translatesAutoresizingMaskIntoConstraints = false

        if let table = tableView {
            let btn = makeStartScreenBtn()
            view.addSubview(btn)
            view.addSubview(table)

            NSLayoutConstraint.activate([
                table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            ])

            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: table.bottomAnchor),
                btn.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                btn.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
                btn.heightAnchor.constraint(equalToConstant: 80.0),
                btn.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    private func makeStartScreenBtn() -> UIButton {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBackground
        btn.setTitleColor(.darkText, for: .normal)
        btn.addTarget(self, action: #selector(startCaptcha), for: .touchUpInside)
        btn.setTitle("Start", for: .normal)
        return btn
    }
    
    private func getCaptchaURL() -> URL? {
        guard var components = URLComponents(string: CAPTCHA_WEBPAGE_URL) else { return nil }
        components.queryItems = settingsModel.queryItems + [URLQueryItem(name: "sitekey", value: SITE_KEY)]
        return components.url
    }
    
    @objc func startCaptcha() {
        
        guard let captchaURL = getCaptchaURL(),
              let validationURL = URL(string: VALIDATION_SERVER_URL)
        else { return }
        
        let controller = StartViewController()
        controller.isInvisibleCaptcha = settingsModel.screenMode == .pixelSquared
        controller.setupController(captchaURL: captchaURL,
                                   validationURL: validationURL,
                                   secretKey: SECRET_KEY)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func makeSettings() {
        sections = [
            SectionModel(headerText: "Captcha open mode", rows: [
                CheckRowModel(labelText: "FullScreen", onValue: { [weak self] in
                    guard let self = self else { return false }
                    return self.settingsModel.screenMode == .fullScreen
                }, onAction: { [weak self ] val in
                    guard let self = self else { return }
                    self.settingsModel.screenMode = val ? .fullScreen : .pixelSquared
                })
            ]),
            SectionModel(headerText: "Captcha result", rows: [
                CheckRowModel(labelText: "Always success", onValue: { [weak self] in
                    guard let self = self else { return false }
                    return self.settingsModel.captchaRecognize == .success
                }, onAction: { [weak self] val in
                    guard let self = self else { return }
                    self.settingsModel.captchaRecognize = val ? .success : .failed
                })
            ])
        ]
    }
}
