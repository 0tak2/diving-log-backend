import Fluent

/**
5. CreateArticle
*/
struct CreateArticle: AsyncMigration {
    func prepare(on database: any Database) async throws {
        return try await database.schema("articles")
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("editor_id", .uuid, .required, .references("members", "id"))
            .field("magazine_id", .int, .required, .references("magazines", "id"))
            .field("order", .int, .required)
            .field("series_id", .int,  .required, .references("series", "id"))
            .field("content", .string, .required)
            .field("content_url", .string)
            .field("content_type", .string, .required)
            .field("accessible_member_level", .int, .required)
            .field("is_deleted", .bool, .required, .sql(.default(false)))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "order")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        return try await database.schema("articles").delete()
    }
}
