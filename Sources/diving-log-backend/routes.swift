import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    try app.register(collection: ArticleController(
            getArticleUsecase: GetArticleUsecase(repository: ArticleRepository())
        )
    )

    try app.register(collection: MagazineController(
            createMagazineUseCase: CreateMagazineUseCase(repository: MagazineRepository())
        )
    )

    try app.register(collection: SeriesController(
        createSeriesUseCase: CreateSeriesUseCase(repository: SeriesRepository())
        )
    )
}
