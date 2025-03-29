import Fluent
import Foundation

final class Member: Model, @unchecked Sendable {
    static let schema = "members"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "apple_oauth_id")
    var appleOAuthId: String

    @Field(key: "nickname")
    var nickname: String

    @Field(key: "is_deleted")
    var isDeleted: Bool

    @Field(key: "member_level")
    var memberLevel: Int

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @OptionalChild(for: \.$member)
    var emailVerification: EmailVerification?

    init() { }

    init(
        id: UUID? = nil, 
        appleOAuthId: String,
        nickname: String,
        isDeleted: Bool,
        memberLevel: Int,
        emailVerification: EmailVerification? = nil,
        createdAt: Date?,
        updatedAt: Date?
    ) {
        self.id = id
        self.appleOAuthId = appleOAuthId
        self.nickname = nickname
        self.isDeleted = isDeleted
        self.memberLevel = memberLevel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
