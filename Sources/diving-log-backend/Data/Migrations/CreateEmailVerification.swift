import Fluent

/**
2. CreateEmailVerification
*/
struct CreateEmailVerification: AsyncMigration {
    func prepare(on database: any Database) async throws {
        return try await database.schema("email_verifications")
            .field("id", .int, .identifier(auto: true))
            .field("member_id", .uuid, .required, .references("members", "id", onDelete: .cascade))
            .unique(on: "member_id")
            .field("email", .string, .required)
            .field("is_verified", .bool, .required, .sql(.default(false)))
            .field("verified_at", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        return try await database.schema("email_verifications").delete()
    }
}
