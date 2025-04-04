import Foundation

enum DomainError: LocalizedError {
    case validationError(String)
    case notFoundError(String)
    case alreadyExistError(String)
    case forbiddenError(String)
    case databaseError(String)
    case internalError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .notFoundError(let message):
            return "찾을 수 없습니다. \(message)"
        case .alreadyExistError(let message):
            return "이미 존재하는 값입니다. \(message)"
        case .forbiddenError(let message):
            return "권한이 없습니다. \(message)"
        case .databaseError(let message):
            return "데이터베이스 문제가 발생했습니다. \(message)"
        case .internalError(let message):
            return "서버 문제가 발생했습니다. \(message)"
        }
    }
}
