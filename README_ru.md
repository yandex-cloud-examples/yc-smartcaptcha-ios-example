# Сервис Yandex SmartCaptcha для iOS

**Структура проекта**

* `./StartViewController.swift`
Хост-контроллер, из которого вызывается капча.

* Директория `./Core`:

  * `SheetPresentationController.swift` и `SheetTransition.swift` используются, если капча будет вызываться в виде шторки.
    Чтобы включить отображение капчи в виде шторки в тестовом проекте, используйте свойство `isSheetCaptchaMode` класса `StartViewController`.

  * `ProtectedController.swift` — экран, который показывается после успешного прохождения капчи.

  * `./Core/Settings UI` — экран настроек для тестирования; вызывается после запуска приложения. На этом экране вызывается `StartViewController`.

    * `Captcha open mode` определяет, будет ли капча отображаться на экране сразу или появится только в случае неудачного прохождения проверки.
    * `Captcha result` определяет результат прохождения проверки; если **Always success = true**, то результат всегда будет считаться успешным.

* Директория `./Core/Validation` — классы для валидации данных, полученных от капчи после запроса к бекенду.

* Директория `./Core/Web` включает классы для работы со следующими сущностями:
    
  * `CaptchaWebContainer.swift` — это класс контейнера для работы с капчей, который включает ссылку на **webView** и передает ее при переключении между контроллерами.
  * `MessageHandler.swift` — класс для обработки сообщений от **webView**.
  * `WebContentController.swift` — контроллер для показа **webView** с капчей.

Данная статья демонстрирует пример настройки капчи, описанный в практическом руководстве [Yandex SmartCaptcha в приложении на iOS](https://cloud.yandex.com/en-ru/docs/smartcaptcha/tutorials/mobile-app/ios/quickstart-ios).
