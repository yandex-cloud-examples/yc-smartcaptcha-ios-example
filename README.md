# Yandex SmartCaptcha for iOS

**Project structure**

* `./StartViewController.swift`
Host controller from which captcha is invoked

* `./Core` directory:

  * `SheetPresentationController.swift` and `SheetTransition.swift` are used if captcha is going to be invoked as a sheet.
    To enable a sheet in a test project, use the `isSheetCaptchaMode` property of the `StartViewController` class.

  * `ProtectedController.swift`: Screen displayed after captcha is successfully passed.

  * `./Core/Settings UI`: Settings screen used for testing and invoked after the app starts. This screen is used to invoke `StartViewController`.

    * `Captcha open mode` determines whether to bring captcha to the screen right away or only after an unsuccessful verification.
    * `Captcha result` determines the verification result; if **Always success = true**, the result will always be considered successful.

* `./Core/Validation` directory: Classes for validating the data supplied by captcha following a request to backend.

* `./Core/Web` directory contains classes for the following entities:
    
  * `CaptchaWebContainer.swift` is a container class for captcha; it includes a link to **webView** and shares it when switching between controllers.
  * `MessageHandler.swift` is a class for listening to messages from **webView**.
  * `WebContentController.swift` is a controller for displaying **webView** with a captcha.
