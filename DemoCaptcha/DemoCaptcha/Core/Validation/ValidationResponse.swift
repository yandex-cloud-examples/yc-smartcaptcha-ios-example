import Foundation

struct ValidationResponse: Decodable {
    var status: String?
    var host: String?
    var message: String?
}
