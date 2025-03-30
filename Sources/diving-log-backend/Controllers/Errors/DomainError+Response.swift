extension DomainError {
    func toResponse() -> BasicResponse<EmptyType> {
        switch self {
            case .validationError:
                return .init(status: 400, message: self.localizedDescription, data: nil)
            case .notFoundError:
                return .init(status: 404, message: self.localizedDescription, data: nil)
            case .databaseError:
                return .init(status: 500, message: self.localizedDescription, data: nil)
            case .alreadyExistError:
                return .init(status: 400, message: self.localizedDescription, data: nil)
            case .internalError:
                return .init(status: 500, message: self.localizedDescription, data: nil)
        }
    }
}
