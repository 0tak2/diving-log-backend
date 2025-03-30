import Foundation
import Vapor

struct MemberEntity: Content {
    let id: UUID?
    let appleOAuthId: String
    let nickname: String
    let isDeleted: Bool
    let memberLevel: Int
    let createdAt: Date
    let updatedAt: Date
    let hasEmailVerified: Bool
    let email: String?
}
