import Foundation
import Fluent

final class EmailVerification: Model, @unchecked Sendable {
    static let schema = "email_verifications"
    
    @ID(custom: .id)
    var id: Int?
    
    @Parent(key: "member_id")
    var member: Member
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "is_verified")
    var isVerified: Bool
    
    @Field(key: "verified_at")
    var verifiedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: Int? = nil, memberId: UUID, email: String, isVerified: Bool = false, verifiedAt: Date? = nil, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.$member.id = memberId
        self.email = email
        self.isVerified = isVerified
        self.verifiedAt = verifiedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
