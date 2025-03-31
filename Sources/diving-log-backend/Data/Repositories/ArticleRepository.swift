import Fluent

final class ArticleRepository: ArticleRepositoryProtocol {
    func get(id: Int, on db: any Database) async throws -> ArticleEntity? {
        let model = try await Article.query(on: db)
        .filter(\.$id == id)
        .first()

        guard let model = model else {
            return nil
        }

        guard let entity = ArticleMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }

    func create(entity: ArticleEntity, on db: any FluentKit.Database) async throws -> ArticleEntity {
        guard let model = ArticleMapper.toModel(entity: entity) else {
            throw RepositoryError.mappingError
        }

        try await model.save(on: db)

        guard let entity = ArticleMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }
}
