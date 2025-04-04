//
//  MemberAuthenticator.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Vapor

struct MemberAuthenticator: AsyncRequestAuthenticator {
    func authenticate(request: Request) async throws {
        guard let accessToken = request.cookies["accessToken"] else {
            return
        }
        
        let jwtPayload: DivingLogJWTPayload = try await request.jwt.verify(accessToken.string, as: DivingLogJWTPayload.self)
        
        guard let memberId = UUID(uuidString: jwtPayload.subject.value) else {
            request.logger.warning("A subject of jwtPayload is not a valid uuidString")
            return
        }
        
        request.auth.login(CurrentUser(id: memberId, nickname: jwtPayload.nickname, level: jwtPayload.level))
    }
}
