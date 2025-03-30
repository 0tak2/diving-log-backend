import Fluent

final class MagazineRepository: MagazineRepositoryProtocol {
    func create(entity: MagazineEntity, on db: any FluentKit.Database) async throws -> MagazineEntity {
        guard let model = MagazineMapper.toModel(entity: entity) else {
            throw DomainError.internalError("변환에 실패했습니다")
        }

        try await model.save(on: db)

        guard let entity = MagazineMapper.toEntity(model: model) else {
            throw DomainError.internalError("변환에 실패했습니다")
        }

        return entity
    }

    func get(issueNumber: Int, on db: any FluentKit.Database) async throws -> MagazineEntity? {
        let model = try await Magazine.query(on: db)
            .filter(\.$issueNumber == issueNumber)
            .first()

        if let model = model {
            return MagazineMapper.toEntity(model: model)
        } else {
            throw DomainError.notFoundError("issueNumber \(issueNumber)인 Magazine은 찾을 수 없습니다")
        }
    }
}
