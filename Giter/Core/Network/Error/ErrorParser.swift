import Foundation

class ErrorParser: AbstractErrorParser {
    func parse(result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}
