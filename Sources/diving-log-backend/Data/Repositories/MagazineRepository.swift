import Fluent

final class MagazineRepository: MagazineRepositoryProtocol {
    func create(entity: MagazineEntity, on db: any FluentKit.Database) async throws -> MagazineEntity {
        guard let model = MagazineMapper.toModel(entity: entity) else {
            throw RepositoryError.mappingError
        }

        try await model.save(on: db)

        guard let entity = MagazineMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }

    func get(issueNumber: Int, on db: any FluentKit.Database) async throws -> MagazineEntity? {
        let model = try await Magazine.query(on: db)
            .filter(\.$issueNumber == issueNumber)
            .first()

        guard let model = model else {
            return nil
        }

        guard let entity = MagazineMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }
}
