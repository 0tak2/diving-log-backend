import Fluent
import Foundation

final class Article: Model, @unchecked Sendable {
    static let schema = "articles"
    
    @ID(custom: .id)
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Parent(key: "editor_id")
    var editor: Member
    
    @Parent(key: "magazine_id")
    var magazine: Magazine

    @Field(key: "order")
    var order: Int
    
    @Parent(key: "series_id")
    var series: Series
    
    @Field(key: "content")
    var content: String
    
    @Enum(key: "content_type")
    var contentType: ContentType

    @Field(key: "content_url")
    var contentUrl: String
    
    @Field(key: "accessible_member_level")
    var accessibleLevel: Int

    @Field(key: "is_deleted")
    var isDeleted: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: Int? = nil, title: String, editorId: UUID, magazineId: Int, seriesId: Int, content: String, contentType: ContentType, contentUrl: String, accessibleLevel: Int, isDeleted: Bool = false, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.title = title
        self.$editor.id = editorId
        self.$magazine.id = magazineId
        self.$series.id = seriesId
        self.content = content
        self.contentUrl = contentUrl
        self.contentType = contentType
        self.accessibleLevel = accessibleLevel
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum ContentType: String, Codable {
        case md = "MD"
        case html = "HTML"
        case notion = "NOTION"
    }
}
