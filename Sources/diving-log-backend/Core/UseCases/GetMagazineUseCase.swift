import Fluent

final class GetMagazineUseCase: BaseUseCase<Int, MagazineEntity>, @unchecked Sendable {
    private let repository: any MagazineRepositoryProtocol

    init(repository: any MagazineRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: Int, on db: (any Database)?) async throws -> MagazineEntity {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }

        do {
            if let entity = try await repository.get(issueNumber: input, on: db) {
                return entity
            } else {
                throw DomainError.notFoundError("id \(input)인 magazine은 존재하지 않습니다")
            }
        } catch let error as RepositoryError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
