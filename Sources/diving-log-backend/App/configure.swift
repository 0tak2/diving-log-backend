import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateMember())
    app.migrations.add(CreateEmailVerification())
    app.migrations.add(CreateMagazine())
    app.migrations.add(CreateSeries())
    app.migrations.add(CreateArticle())

    app.views.use(.leaf) // for admin page

    app.middleware.use(ErrorMiddleware())

    app.sessions.configuration.cookieFactory = { sessionID in
        .init(string: sessionID.string, isSecure: true, isHTTPOnly: true, sameSite: HTTPCookies.SameSitePolicy.none)
    }
    app.middleware.use(app.sessions.middleware) // for OAuth

    // MARK: Log
    app.logger.logLevel = .debug

    // MARK: encoder and decoder
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    decoder.dateDecodingStrategy = .secondsSince1970

    ContentConfiguration.global.use(encoder: encoder, for: .json)
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    // register routes
    try routes(app)
}
