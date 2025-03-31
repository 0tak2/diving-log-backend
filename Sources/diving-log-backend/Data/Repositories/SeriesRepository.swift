import Fluent

final class SeriesRepository: SeriesRepositoryProtocol {
    func create(entity: SeriesEntity, on db: any FluentKit.Database) async throws -> SeriesEntity {
        guard let model = SeriesMapper.toModel(entity: entity) else {
            throw RepositoryError.mappingError
        }

        try await model.save(on: db)

        guard let entity = SeriesMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }

    func get(id: Int, on db: any FluentKit.Database) async throws -> SeriesEntity? {
        let model = try await Series.query(on: db)
            .filter(\.$id == id)
            .first()

        guard let model = model else {
            return nil
        }

        guard let entity = SeriesMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }
}
