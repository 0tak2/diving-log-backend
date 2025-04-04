import Fluent

final class GetArticleUsecase: BaseUseCase<GetArticleDTO, ArticleEntity?>, @unchecked Sendable {
    private let repository: any ArticleRepositoryProtocol

    init(repository: any ArticleRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: GetArticleDTO, on db: (any Database)?) async throws -> ArticleEntity? {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }
        
        let id = input.articleId
        let user = input.requestedBy

        do {
            guard let entity = try await repository.get(id: id, on: db) else {
                return nil
            }
            
            if entity.accessibleLevel <= user.level {
                return entity
            } else {
                throw DomainError.forbiddenError("게시글 조회 권한이 없습니다")
            }
        } catch let error as RepositoryError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
