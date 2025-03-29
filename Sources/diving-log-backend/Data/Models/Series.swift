import Fluent
import Foundation

final class Series: Model, @unchecked Sendable {
    static let schema = "series"
    
    @ID(custom: .id)
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Parent(key: "creator_id")
    var creator: Member
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    // Relationships
    @Children(for: \.$series)
    var articles: [Article]
    
    init() {}
    
    init(id: Int? = nil, title: String, description: String, creatorId: UUID, createdAt: Date?, updatedAt: Date?) {
        self.id = id
        self.title = title
        self.description = description
        self.$creator.id = creatorId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
