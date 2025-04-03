//
//  IdTokenPayload.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

struct IdTokenPayload: Codable {
    let iss: String
    let aud: String
    let exp: Int
    let iat: Int
    let sub: String
    let nonce: String
    let c_hash: String
    let auth_time: Int
    let nonce_supported: Bool
}
