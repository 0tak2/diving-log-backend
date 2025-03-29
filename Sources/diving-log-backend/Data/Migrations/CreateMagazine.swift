import Fluent

/**
3. CreateMagazine
*/
struct CreateMagazine: AsyncMigration {
    func prepare(on database: any Database) async throws {
        return try await database.schema("magazines")
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("issue_number", .int, .required)
            .field("publish_date", .datetime, .required)
            .field("creator_id", .uuid, .required, .references("members", "id"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        return try await database.schema("magazines").delete()
    }
}
