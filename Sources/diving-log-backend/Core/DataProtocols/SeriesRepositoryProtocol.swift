import Fluent

protocol SeriesRepositoryProtocol {
    func create(entity: SeriesEntity, on db: any Database) async throws -> SeriesEntity
    func get(id: Int, on db: any FluentKit.Database) async throws -> SeriesEntity?
}
