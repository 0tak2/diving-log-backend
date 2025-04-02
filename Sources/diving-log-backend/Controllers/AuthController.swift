import Fluent
import Vapor
import Crypto

struct AuthController: RouteCollection {
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

    func appleLoginRedirect(req: Request) async throws -> HTTPStatus {
        let received = try req.content.decode(AppleSignInRedirectDTO.self)

        if let state = req.session.data["state"],
           state == received.state {
            print(received)
            print(received.userDTO)
            print("sign in success")
            // TODO: decode id_token
            // TODO: register
            // TODO: register

            let idTokenPayloadRaw = received.id_token.split(separator: ".")[1]
            let idTokenPayloadRawData = idTokenPayloadRaw.data(using: .utf8)!

            if let data = Data(base64Encoded: idTokenPayloadRawData) {
                print(String(data: data, encoding: .utf8))
            }

            return .ok
        }

        print("sign in failed... prevState=\(req.session.data["state"] ?? "nil") received=\(received.state)")
        return .badRequest
    }
}
