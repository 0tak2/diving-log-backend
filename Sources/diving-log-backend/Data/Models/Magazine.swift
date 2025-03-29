import Fluent
import Foundation

final class Magazine: Model, @unchecked Sendable {
    static let schema = "magazines"
    
    @ID(custom: .id)
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "issue_number")
    var issueNumber: Int
    
    @Field(key: "publish_date")
    var publishDate: Date
    
    @Parent(key: "creator_id")
    var creator: Member
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$magazine)
    var articles: [Article]
    
    init() {}
    
    init(id: Int? = nil, title: String, issueNumber: Int, publishDate: Date, creatorId: UUID, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.title = title
        self.issueNumber = issueNumber
        self.publishDate = publishDate
        self.$creator.id = creatorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
