import Foundation
import Alamofire

class RequestFactory: AbstractRequestFactory {
    
    @discardableResult
    func getUser(completionHandler: @escaping (DataResponse<User>) -> Void) -> DataRequest {
        return self.sessionManager
            .request(RequestRouter.getUser()).responseCodable(errorParser: errorParser, completionHandler: completionHandler)
    }
    
    func getRepositories(completionHandler: @escaping (DataResponse<[Repository]>) -> Void) -> DataRequest {
        return self.sessionManager
            .request(RequestRouter.getRepositories())
            .responseCodable(errorParser: errorParser, completionHandler: completionHandler)
    }
}
