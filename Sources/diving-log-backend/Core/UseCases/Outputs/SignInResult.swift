//
//  File.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Foundation

struct SignInResult: Codable {
    let member: MemberEntity
    let firstSignIn: Bool
}
