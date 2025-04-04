import Foundation
import Vapor

struct BasicResponse<T: Content>: Content {
    let status: Int
    let message: String
    let data: T?

    static func okay(data: T?) -> BasicResponse<T> {
        return .init(status: 200, message: "Okay", data: data)
    }
    
    static func notFound() -> BasicResponse<T> {
        return .init(status: 404, message: "Not Found", data: nil)
    }
}

struct EmptyType: Content {}

extension DomainError {
    var response: BasicResponse<EmptyType> {
        return BasicResponse(status: Int(status.code), message: localizedDescription, data: nil)
    }
    
    var status: HTTPStatus {
        switch self {
        case .notFoundError:
            return .notFound
        case .validationError:
            return .badRequest
        case .alreadyExistError:
            return .badRequest
        case .forbiddenError:
            return .forbidden
        case .databaseError:
            return .internalServerError
        case .internalError:
            return .internalServerError
        }
    }
}
