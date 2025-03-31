import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    let articleRepository: any ArticleRepositoryProtocol = ArticleRepository()
    let magazineRepository: any MagazineRepositoryProtocol = MagazineRepository()
    let seriesRepository: any SeriesRepositoryProtocol = SeriesRepository()

    try app.register(collection: ArticleController(
        getArticleUsecase: GetArticleUsecase(repository: articleRepository),
        createMagazineUseCase: CreateArticleUseCase(repository: articleRepository)
    ))

    try app.register(collection: MagazineController(
        createMagazineUseCase: CreateMagazineUseCase(repository: magazineRepository)
    ))

    try app.register(collection: SeriesController(
        createSeriesUseCase: CreateSeriesUseCase(repository: seriesRepository)
    ))
}
