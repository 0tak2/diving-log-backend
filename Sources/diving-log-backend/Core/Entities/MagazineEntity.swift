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

    static func emptyOf(id: Int) -> MagazineEntity {
        MagazineEntity(
            id: id,
            title: "",
            issueNumber: 0,
            publishDate: Date(),
            creator: nil,
            createdAt: nil,
            updatedAt: nil
        )
    }
}
