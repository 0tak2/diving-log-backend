import Fluent
import Vapor
import Crypto

struct AuthController: RouteCollection {
    private let redirectUrlNormal: String
    private let redirectUrlWhenFirstLogin: String
    private let signInUseCase: BaseUseCase<Request, SignInResult>
    
    init(redirectUrlNormal: String, redirectUrlWhenFirstLogin: String, signInUseCase: BaseUseCase<Request, SignInResult>) {
        self.redirectUrlNormal = redirectUrlNormal
        self.redirectUrlWhenFirstLogin = redirectUrlWhenFirstLogin
        self.signInUseCase = signInUseCase
    }
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        let signInWithAppleRoutes = auth.grouped("signInWithApple")
        signInWithAppleRoutes.get(use: self.signInWithApple)

        let appleLoginRedirectRoutes = auth.grouped("appleLoginRedirect")
        appleLoginRedirectRoutes.post(use: self.appleLoginRedirect)
    }

    func signInWithApple(req: Request) async throws -> View {
        guard let host = req.headers.first(name: "host") else {
            req.logger.error("no host header... cannot get full redirectUri")
            return try await req.view.render("error", ["errorMessage": "host 헤더가 없습니다."])
        }

        let state = UUID().uuidString
        req.session.data["state"] = state

        // MARK: Generate nonce
        // see: https://stackoverflow.com/a/61025726
        let nonce = ChaChaPoly.Nonce.init()
        let nonceString = Data(nonce).base64EncodedString()

        return try await req.view.render("signInWithApple", [
            "clientId": "com.divinglog.web",
            "scope": "name",
            "redirectUri": "https://\(host)/auth/appleLoginRedirect",
            "state": state,
            "nonce": nonceString
        ])
    }

    func appleLoginRedirect(req: Request) async throws -> Response {
        let signInResult = try await signInUseCase.execute(req, on: req.db)
        
        // TODO: Issue JWT and set cookie
        
        if signInResult.firstSignIn {
            return Response(status: .found, headers: ["Location": redirectUrlNormal])
        }
        
        return Response(status: .found, headers: ["Location": redirectUrlWhenFirstLogin])
    }
}
