import Vapor

struct CreateSeriesDTO: Content {
    let title: String
    let description: String
}
