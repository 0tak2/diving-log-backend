import Fluent

final class MemberRepository: MemberRepositoryProtocol {
    func get(appleOAuthId: String, on db: any FluentKit.Database) async throws -> MemberEntity? {
        let model = try await Member.query(on: db)
            .filter(\.$appleOAuthId == appleOAuthId)
            .first()
        
        guard let model = model else {
            return nil
        }
        
        return MemberMapper.toEntity(model: model)
    }
    
    func create(entity: MemberEntity, on db: any FluentKit.Database) async throws -> MemberEntity {
        guard let model = MemberMapper.toModel(entity: entity) else {
            throw RepositoryError.mappingError
        }

        try await model.save(on: db)

        guard let entity = MemberMapper.toEntity(model: model) else {
            throw RepositoryError.mappingError
        }

        return entity
    }
}
