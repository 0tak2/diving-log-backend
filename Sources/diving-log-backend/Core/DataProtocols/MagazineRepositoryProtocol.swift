import Fluent

protocol MagazineRepositoryProtocol {
    func create(entity: MagazineEntity, on db: any Database) async throws -> MagazineEntity
    func get(issueNumber: Int, on db: any FluentKit.Database) async throws -> MagazineEntity?
}
