import Foundation
import Vapor

struct MagazineEntity: Content {
    let id: Int?
    let title: String
    let issueNumber: Int
    let publishDate: Date
    let creator: MemberEntity?
    let createdAt: Date?
    let updatedAt: Date?
}
