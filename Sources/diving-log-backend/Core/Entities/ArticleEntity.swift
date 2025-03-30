import Foundation
import Vapor

struct ArticleEntity: Content {
    let id: Int?
    let title: String
    let editor: MemberEntity?
    let magazine: MagazineEntity?
    let order: Int
    let series: SeriesEntity?
    let content: String
    let contentType: ContentType
    let contentUrl: String
    let isDeleted: Bool
    let accessibleLevel: Int
    let createdAt: Date
    let updatedAt: Date

    enum ContentType: String, Codable {
        case md = "MD"
        case html = "HTML"
        case notion = "NOTION"
    }
}
