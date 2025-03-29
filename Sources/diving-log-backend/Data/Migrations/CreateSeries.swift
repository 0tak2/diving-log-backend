import Fluent

/**
4. CreateSeries
*/
struct CreateSeries: AsyncMigration {
     func prepare(on database: any Database) async throws {
        return try await database.schema("series")
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("creator_id", .uuid, .required, .references("members", "id"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        return try await database.schema("series").delete()
    }
}
