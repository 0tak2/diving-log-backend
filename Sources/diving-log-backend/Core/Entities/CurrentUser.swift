//
//  User.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/3/25.
//

import Vapor

struct CurrentUser: Authenticatable {
    let id: UUID
    let nickname: String
    let level: Int
}
