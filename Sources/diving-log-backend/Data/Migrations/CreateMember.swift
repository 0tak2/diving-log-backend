import Fluent

/**
1. CreateMember
*/
struct CreateMember: AsyncMigration {
    func prepare(on database: any Database) async throws {
        return try await database.schema("members")
            .id()
            .field("apple_oauth_id", .string)
            .field("nickname", .string, .required)
            .field("is_deleted", .bool, .required, .sql(.default(false)))
            .field("member_level", .int, .required, .sql(.default(0)))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        return try await database.schema("members").delete()
    }
}
