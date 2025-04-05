import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    let articleRepository: any ArticleRepositoryProtocol = ArticleRepository()
    let magazineRepository: any MagazineRepositoryProtocol = MagazineRepository()
    let seriesRepository: any SeriesRepositoryProtocol = SeriesRepository()
    let memberRepository: any MemberRepositoryProtocol = MemberRepository()

    try app.register(collection: ArticleController(
        getArticleUsecase: GetArticleUsecase(repository: articleRepository),
        getAllArticlesInMagazineUseCase: GetAllArticlesInMagazineUseCase(repository: articleRepository),
        createMagazineUseCase: CreateArticleUseCase(repository: articleRepository)
    ))

    try app.register(collection: MagazineController(
        createMagazineUseCase: CreateMagazineUseCase(repository: magazineRepository),
        getMagazineUseCase: GetMagazineUseCase(repository: magazineRepository)
    ))

    try app.register(collection: SeriesController(
        createSeriesUseCase: CreateSeriesUseCase(repository: seriesRepository)
    ))

    try app.register(collection: AuthController(
        redirectUrlNormal: Environment.get("LOGIN_REDIRECT_URL") ?? "/",
        redirectUrlWhenFirstLogin: Environment.get("LOGIN_REDIRECT_URL_FIRST_LOGIN") ?? "/",
        accessTokenExpiresInDays: Int(Environment.get("ACCESS_TOKEN_EXPIRES_IN_DAYS") ?? "1") ?? 1,
        signInUseCase: SignInUseCase(repository: memberRepository),
        sendEmailUseCase: SendAcademyVerificationMailUseCase(
            allowableEmailDomain: [
                "pos.idserve.net",
                Environment.get("ADDITIONAL_ALLOWABLE_EMAIL_DOMAIN_1") ?? "",
                Environment.get("ADDITIONAL_ALLOWABLE_EMAIL_DOMAIN_2") ?? "",
                Environment.get("ADDITIONAL_ALLOWABLE_EMAIL_DOMAIN_3") ?? "",
            ],
            mailSender: MailGunSender(
                mailGunApiKey: Environment.get("EMAIL_MAILGUN_API_KEY")!,
                mailSendBy: Environment.get("EMAIL_SENDER_NAME")!,
                mailDomain: Environment.get("EMAIL_SENDER_DOMAIN")!
            ),
            repository: memberRepository
        )
    ))
}
