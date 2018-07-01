import Foundation
import Alamofire

class OAuthRequestFactory: AbstractRequestFactory {
    
    func getOAuthCode(clientId: String,
               scopes: String,
               redirectURL: String) -> DataRequest {
        
        let parameters: Parameters = ["client_id" : clientId, "scope" : scopes, "redirect_uri" : redirectURL]
        return self.sessionManager.request(AuthRequestRouter.getOAuthCode(parameters: parameters))
    }
    
    @discardableResult
    func getOAuthAccessToken(clientId: String,
                        clientSecret: String,
                        code: String,
                        completionHandler: @escaping (DataResponse<LoginResponse>) -> Void) -> DataRequest {
        
        let parameters: Parameters = ["client_id" : clientId, "client_secret" : clientSecret, "code" : code]
        
        return self.sessionManager
                   .request(AuthRequestRouter.getOAuthAccessToken(parameters: parameters))
                   .responseCodable(errorParser: errorParser, completionHandler: completionHandler)
    }
}
