//
//  EmailSendable.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/5/25.
//

import Foundation

protocol EmailSendable {
    func send(nameTo name: String, emailTo email: String, subject: String, body: String) async throws
}
