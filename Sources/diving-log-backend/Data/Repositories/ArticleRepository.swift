import Fluent

final class ArticleRepository: ArticleRepositoryProtocol {
    func get(id: Int, on db: any Database) async throws -> ArticleEntity {
        let model = try await Article.query(on: db)
        .filter(\.$id == id)
        .first()

        guard let model = model else {
            throw DomainError.notFoundError("id \(id)인 아티클은 존재하지 않습니다")
        }

        guard let entity = ArticleMapper.toEntity(model: model) else {
            throw DomainError.internalError("변환에 실패했습니다")
        }

        return entity
    }
}
