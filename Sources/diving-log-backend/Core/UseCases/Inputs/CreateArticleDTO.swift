import Vapor

struct CreateArticleDTO: Content {
    let title: String
    let magazineId: Int
    let order: Int
    let seriesId: Int
    let content: String
    let contentType: String
    let contentUrl: String?
    let accessibleLevel: Int
}
