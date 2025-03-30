import Fluent

protocol UseCase {
    associatedtype Input
    associatedtype Output
}

class BaseUseCase<Input, Output>: UseCase, @unchecked Sendable {
    func execute(_ input: Input, on db: (any Database)?) async throws -> Output {
        fatalError("Subclasses must override this method.")
    }
}
