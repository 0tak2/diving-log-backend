import Vapor

struct CreateMagazineDTO: Content {
    let title: String
    let issueNumber: Int
    let publishDate: Date
}
