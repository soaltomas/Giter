import Foundation
import Alamofire

/// Фабрика для генерации запросов
class AbstractRequestFactory {
    let sessionManager: SessionManager
    let errorParser: AbstractErrorParser
    let queue: DispatchQueue
    
    init(sessionManager: SessionManager = SessionManagerFactory.getSessionManager(),
         errorParser: AbstractErrorParser = ErrorParser(),
         queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.sessionManager = sessionManager
        self.errorParser = errorParser
        self.queue = queue
    }
}

extension DataRequest {
    @discardableResult
    func responseCodable<T: Decodable> (errorParser: AbstractErrorParser,
                                        queue: DispatchQueue? = nil,
                                        completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            if let error = errorParser.parse(response: response, data: data, error: error) {
                return .failure(error)
            }
            
            let result = Request.serializeResponseData(response: response, data: data, error: nil)
            
            switch result {
            case .success(let data):
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    return .success(value)
                } catch {
                    let customError = errorParser.parse(result: error)
                    return .failure(customError)
                }
            case .failure(let error):
                let customError = errorParser.parse(result: error)
                return .failure(customError)
            }
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
