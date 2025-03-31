import Foundation
import Vapor

struct SeriesEntity: Content {
    let id: Int?
    let title: String
    let description: String
    let creator: MemberEntity?
    let createdAt: Date?
    let updatedAt: Date?

    static func emptyOf(id: Int) -> SeriesEntity {
        SeriesEntity(
            id: id,
            title: "",
            description: "",
            creator: nil,
            createdAt: nil,
            updatedAt: nil
        )
    }
}
