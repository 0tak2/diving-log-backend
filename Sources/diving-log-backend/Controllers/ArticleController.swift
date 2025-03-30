import Fluent
import Vapor

struct ArticleController: RouteCollection {
    let getArticleUsecase: BaseUseCase<Int, ArticleEntity>

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let articles = routes.grouped("articles")

        articles.group(":id") { article in
            article.get(use: self.get)
        }
    }

    func get(req: Request) async throws -> BasicResponse<ArticleEntity> {
        guard let idParameter = req.parameters.get("id"),
              let id = Int(idParameter) else {
                throw ControllerError.validationError("id가 필요합니다")
        }

        let article = try await getArticleUsecase.execute(id, on: req.db)
        return BasicResponse.okay(data: article)
    }
}
