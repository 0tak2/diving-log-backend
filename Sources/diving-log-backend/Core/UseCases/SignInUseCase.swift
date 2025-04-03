//
//  SignInUseCase.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Vapor
import Fluent

final class SignInUseCase: BaseUseCase<Request, SignInResult>, @unchecked Sendable {
    private let repository: any MemberRepositoryProtocol
    
    init(repository: any MemberRepositoryProtocol) {
        self.repository = repository
    }
    
    private let logger = CustomLoggerProvider.of("SignInUseCase")
    
    override func execute(_ req: Request, on db: (any Database)?) async throws -> SignInResult {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }
        
        let received = try req.content.decode(AppleSignInRedirectDTO.self)
        guard let state = req.session.data["state"],
           state == received.state else {
            throw DomainError.validationError("session 내 state 데이터가 잘못되었습니다.")
        }
        
        logger.debug("sign in success... user: \(String(describing: received.userDTO))")

        let idTokenPayloadRaw = received.id_token.split(separator: ".")[1] // BASE64 string
        guard let isTokenPayloadDecodedData = Data(base64Encoded: String(idTokenPayloadRaw)),
              let idTokenPayloadJsonString = String(data: isTokenPayloadDecodedData, encoding: .utf8),
              let idTokenPayloadJsonData = idTokenPayloadJsonString.data(using: .utf8) else {
            throw DomainError.internalError("토큰 파싱에 실패했습니다")
        }
        
        let decoder = JSONDecoder()
        let idTokenPayload = try decoder.decode(IdTokenPayload.self, from: idTokenPayloadJsonData)
        let appleLoginSub = idTokenPayload.sub

        do {
            if let existingEntity = try await repository.get(appleOAuthId: appleLoginSub, on: db) {
                return SignInResult(member: existingEntity, firstSignIn: false)
            }
            
            let signedInEntity = try await repository.create(
                entity: MemberEntity(
                    id: UUID(),
                    appleOAuthId: appleLoginSub,
                    nickname: received.userDTO?.name.firstName ?? "N/A",
                    isDeleted: false,
                    memberLevel: 1,
                    createdAt: nil,
                    updatedAt: nil,
                    hasEmailVerified: false,
                    email: nil
                ),
                on: db
            )
            return SignInResult(member: signedInEntity, firstSignIn: true)
        } catch let error as RepositoryError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
