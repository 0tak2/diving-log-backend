import Foundation

enum RepositoryError: LocalizedError {
    case validationError(String)
    case alreadyExistError(String)
    case mappingError
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .alreadyExistError(let message):
            return "이미 존재하는 값입니다. \(message)"
        case .mappingError:
            return "매핑 중 오류가 발생했습니다."
        }
    }
}
