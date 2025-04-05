import Foundation

enum InfraError: LocalizedError {
    case validationError(String)
    case thirdPartyError(String)
    case internalError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .thirdPartyError(let message):
            return "외부 서버에서 오류가 발생했습니다. \(message)"
        case .internalError(let message):
            return "내부 문제가 발생했습니다. \(message)"
        }
    }
}
