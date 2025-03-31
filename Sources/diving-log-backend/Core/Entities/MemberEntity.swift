import Foundation
import Vapor

struct MemberEntity: Content {
    let id: UUID?
    let appleOAuthId: String
    let nickname: String
    let isDeleted: Bool
    let memberLevel: Int
    let createdAt: Date?
    let updatedAt: Date?
    let hasEmailVerified: Bool
    let email: String?

    static func emptyOf(id: UUID) -> MemberEntity {
        MemberEntity(
            id: id,
            appleOAuthId: "",
            nickname: "",
            isDeleted: false,
            memberLevel: 0,
            createdAt: nil,
            updatedAt: nil,
            hasEmailVerified: false,
            email: nil
        )
    }
}
