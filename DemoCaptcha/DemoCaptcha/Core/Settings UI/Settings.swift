import Foundation

struct Settings {
    enum CaptchaRecognize {
        case random, success, failed
    }
    
    enum ScreenMode {
        case fullScreen, pixelSquared
    }
    
    var screenMode: Self.ScreenMode
    var captchaRecognize: Self.CaptchaRecognize
}

extension Settings {
    var queryItems: [URLQueryItem] {
        var result = [URLQueryItem]()
        if screenMode == .pixelSquared {
            result.append(URLQueryItem(name: "invisible", value: "true"))
        }
        if captchaRecognize == .failed {
            result.append(URLQueryItem(name: "test", value: "true"))
        }
        
        return result
    }
}
