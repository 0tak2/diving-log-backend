import Vapor

struct AppleSignInRedirectDTO: Content {
    let state: String
    let id_token: String
}
