import Foundation

struct LoginResponse: Codable {
    
    var accessToken: String
    var scope: String
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
