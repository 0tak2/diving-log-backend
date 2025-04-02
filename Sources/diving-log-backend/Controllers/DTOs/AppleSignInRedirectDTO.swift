import Vapor

struct AppleSignInRedirectDTO: Content {
    let state: String
    let code: String
    let id_token: String
    let user: String? // only first sign in
    var userDTO: AppleUserDTO? {
        if let user = user,
           let userData = user.data(using: .utf8) {
            return try? JSONDecoder().decode(AppleUserDTO.self, from: userData)
        }
        return nil
    }

    struct AppleUserDTO: Codable {
        let name: AppleUserNameDTO
    }

    struct AppleUserNameDTO: Codable {
        let firstName: String
        let lastName: String
    }
}
