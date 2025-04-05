import Vapor

struct SendVerificationEmailRequestDTO: Content {
    let emailTo: String // DO NOT INCLUDE "@DOMAIN". just pass username of email address.
}
