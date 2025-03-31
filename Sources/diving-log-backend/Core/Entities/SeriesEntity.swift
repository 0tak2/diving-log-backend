import Foundation
import Vapor

struct SeriesEntity: Content {
    let id: Int?
    let title: String
    let description: String
    let creator: MemberEntity?
    let createdAt: Date?
    let updatedAt: Date?
}
