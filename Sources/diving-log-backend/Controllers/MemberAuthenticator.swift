//
//  MemberAuthenticator.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Vapor

struct MemberAuthenticator: AsyncRequestAuthenticator {
    /**
        인가 가능한 권한이면 true를, 권한이 부족하면 false를 반환
     */
    private let levelCheckHandler: @Sendable (_ currentLevel: Int) -> Bool
    
    init(levelCheckHandler: @Sendable @escaping (_ currentLevel: Int) -> Bool) {
        self.levelCheckHandler = levelCheckHandler
    }
    
    init() {
        self.init { _ in true }
    }
    
    func authenticate(request: Request) async throws {
        guard let accessToken = request.cookies["accessToken"] else {
            return
        }
        
        let jwtPayload: DivingLogJWTPayload = try await request.jwt.verify(accessToken.string, as: DivingLogJWTPayload.self)
        guard levelCheckHandler(jwtPayload.level) else {
            request.logger.warning("level of the user is insufficient")
            return
        }
        
        guard let memberId = UUID(uuidString: jwtPayload.subject.value) else {
            request.logger.warning("The subject of jwtPayload is not a valid uuidString")
            return
        }
        
        request.auth.login(CurrentUser(id: memberId, nickname: jwtPayload.nickname, level: jwtPayload.level))
    }
}
