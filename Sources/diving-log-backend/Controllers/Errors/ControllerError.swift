import Foundation

enum ControllerError: LocalizedError {
    case validationError(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        }
    }

    func toResponse() -> BasicResponse<EmptyType> {
        switch self {
            case .validationError:
                return .init(status: 400, message: self.localizedDescription, data: nil)
        }
    }
}
