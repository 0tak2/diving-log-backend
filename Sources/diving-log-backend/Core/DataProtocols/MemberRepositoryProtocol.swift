import Fluent

protocol MemberRepositoryProtocol {
    func get(appleOAuthId: String, on db: any Database) async throws -> MemberEntity?
    func create(entity: MemberEntity, on db: any Database) async throws -> MemberEntity
}
