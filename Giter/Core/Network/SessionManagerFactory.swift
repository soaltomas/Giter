import Foundation
import Alamofire

/// Фабрика для генерации SessionManager
class SessionManagerFactory {
    
    static func getSessionManager() -> SessionManager {
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Authorization" : "token \(currentAccessToken == nil ? "" : currentAccessToken!)"]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        configuration.httpShouldSetCookies = false
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return SessionManager(configuration: configuration)
    }
}
