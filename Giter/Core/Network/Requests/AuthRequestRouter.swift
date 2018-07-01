import Foundation
import Alamofire

enum AuthRequestRouter: URLRequestConvertible {
    
    static let baseURLString = "https://github.com/login/oauth"
    
    case getOAuthCode(parameters: Parameters)
    case getOAuthAccessToken(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getOAuthCode:
            return .get
        case .getOAuthAccessToken:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getOAuthCode:
            return "/authorize"
        case .getOAuthAccessToken:
            return "/access_token"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try AuthRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getOAuthCode(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getOAuthAccessToken(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
