//
//  DivingLogJWTPayload.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import JWT

// JWT payload structure.
struct DivingLogJWTPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case nickname = "nickname"
        case expiration = "exp"
        case level = "level"
    }

    var subject: SubjectClaim
    
    var nickname: String

    var expiration: ExpirationClaim

    var level: Int

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}
