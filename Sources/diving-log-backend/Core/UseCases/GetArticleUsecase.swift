import Fluent

final class GetArticleUsecase: BaseUseCase<Int, ArticleEntity>, @unchecked Sendable {
    private let repository: any ArticleRepositoryProtocol

    init(repository: any ArticleRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: Int, on db: (any Database)?) async throws -> ArticleEntity {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }

        return try await repository.get(id: input, on: db)
    }
}
