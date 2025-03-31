import Fluent
import Foundation

final class CreateArticleUseCase: BaseUseCase<CreateArticleDTO, ArticleEntity>, @unchecked Sendable {
    private let repository: any ArticleRepositoryProtocol

    init(repository: any ArticleRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: CreateArticleDTO, on db: (any Database)?) async throws -> ArticleEntity {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }

        guard let contentType = ArticleEntity.ContentType(rawValue: input.contentType.uppercased()) else {
            throw DomainError.validationError("contentType이 잘못되었습니다")
        }

        do {
            let entity = ArticleEntity(
                id: nil,
                title: input.title,
                editor: MemberEntity.emptyOf(id: UUID(uuidString: "ff30a6a6-8a3a-4a7a-911b-a67925f0a6c0")!), // FIXME
                magazine: MagazineEntity.emptyOf(id: input.magazineId),
                order: input.order,
                series: SeriesEntity.emptyOf(id: input.seriesId),
                content: input.content,
                contentType: contentType,
                contentUrl: input.contentUrl,
                isDeleted: false,
                accessibleLevel: input.accessibleLevel,
                createdAt: nil,
                updatedAt: nil
            )
            return try await self.repository.create(entity: entity, on: db)
        } catch let error as RepositoryError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
