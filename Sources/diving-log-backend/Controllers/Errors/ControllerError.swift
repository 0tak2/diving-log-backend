import Foundation

enum ControllerError: LocalizedError {
    case validationError(String)
    case convertDTOFailedError(String)
    case needLoginError
    case forbiddenError
    
    public var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return "값 검증에 실패했습니다. \(message)"
        case .convertDTOFailedError(let message):
            return "DTO 변환에 실패했습니다. \(message)"
        case .needLoginError:
            return "로그인이 필요합니다."
        case .forbiddenError:
            return "권한이 없습니다."
        }
    }

    func toResponse() -> BasicResponse<EmptyType> {
        switch self {
        case .validationError:
            return .init(status: 400, message: self.localizedDescription, data: nil)
        case .convertDTOFailedError:
            return .init(status: 500, message: self.localizedDescription, data: nil)
        case .needLoginError:
            return .init(status: 401, message: self.localizedDescription, data: nil)
        case .forbiddenError:
            return .init(status: 403, message: self.localizedDescription, data: nil)
        }
    }
}
