import Fluent

protocol ArticleRepositoryProtocol {
    func get(id: Int, on db: any Database) async throws -> ArticleEntity
}
