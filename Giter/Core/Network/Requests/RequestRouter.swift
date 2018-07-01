import Foundation
import Alamofire

enum RequestRouter: URLRequestConvertible {
    
    static let baseURLString = "https://api.github.com"
    
    static var currentUser: User = User()
    
    case getUser()
    case getRepositories()
    
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
            return .get
        case .getRepositories:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/user"
        case .getRepositories:
           // return "/users/\(String(describing: RequestRouter.currentUser.login))/repos"
            return "/users/soaltomas/repos"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try RequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
//        switch self {
//        case .getUser():
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        case .getUserRepo():
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        default:
//            break
//        }
        
        return urlRequest
    }
}
