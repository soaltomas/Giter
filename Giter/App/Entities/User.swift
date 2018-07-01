import Foundation

struct User: Codable {
    
    var id: Int?
    var login: String = ""
    var name: String?
    var company: String?
    var email: String?
    var biography: String?
    var repoAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case company
        case email
        case biography = "bio"
        case repoAmount = "public_repos"
    }
}
