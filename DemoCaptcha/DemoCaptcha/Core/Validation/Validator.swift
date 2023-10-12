import Foundation

protocol ValidatorProtocol {
    func validateCaptcha(token: String, callback: @escaping (Result<String, Error>) -> Void)
}

enum ValidatorError: Error {
    case empty
    case server(code: Int, text: String?)
    case parsing
    case api(code: Int, text: String?, status: String?)
}


final class Validator: ValidatorProtocol  {
    private var url: URL
    private var secret: String
    private var session: URLSession

    init(url: URL, secret: String) {
        self.url = url
        self.secret = secret
        session = URLSession(configuration: .default)
    }

    func validateCaptcha(token: String, callback: @escaping (Result<String, Error>) -> Void) {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        components.queryItems = [
            URLQueryItem(name: "secret", value: secret),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "ip", value: getIPAddress()),
        ]
        session.dataTask(with: URLRequest(url: components.url!)) { data, response, error in
            var res = ValidationResponse()
            res.host = "OK"
            guard let code = (response as? HTTPURLResponse)?.statusCode else {
                callback(.failure(ValidatorError.empty))
                return
            }
            guard code == 200 else {
                callback(.failure(ValidatorError.server(code: code, text: error?.localizedDescription)))
                return
            }
            guard let data = data,
                  let result = try? JSONDecoder().decode(ValidationResponse.self, from: data) else { return }
            if result.status == "ok" {
                callback(.success(result.host ?? ""))
            } else {
                callback(.failure(ValidatorError.api(code: code, text: result.message, status: result.status)))
            }
        }.resume()
    }

    private func getIPAddress() -> String {
        var address: String = ""
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer {
                    ptr = ptr?.pointee.ifa_next
                }

                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) {

                    if String(cString: (interface?.ifa_name)!) == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        print(address)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
}
