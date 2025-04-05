//
//  SendAcademyVerificationMail.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/5/25.
//

import Foundation
import Fluent

final class SendAcademyVerificationMailUseCase: BaseUseCase<SendVerificationEmailInput, Void>, @unchecked Sendable {
    private let allowableEmailDomain: Set<String>
    private let mailSender: any EmailSendable
    private let repository: any MemberRepositoryProtocol
    
    init(allowableEmailDomain: Set<String>, mailSender: any EmailSendable, repository: any MemberRepositoryProtocol) {
        self.allowableEmailDomain = allowableEmailDomain
        self.mailSender = mailSender
        self.repository = repository
    }
    
    override func execute(_ input: SendVerificationEmailInput, on db: (any Database)?) async throws -> Void {
        guard isValidEmail(input.email) else {
            throw DomainError.validationError("올바른 이메일 형식이 아닙니다")
        }
        
        let domain = String(input.email.split(separator: "@")[1])
        guard allowableEmailDomain.contains(domain) else {
            throw DomainError.validationError("허용된 이메일이 아닙니다")
        }
        
        let randomDigits = getRandomDigits()
        
        try await mailSender.send(nameTo: input.name, emailTo: input.email, subject: "아카데미 구성원 인증 메일", body: "인증 번호: \(randomDigits)")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: emailRegex) != nil
    }
    
    func getRandomDigits(count: Int = 6) -> String {
        (0..<count).reduce("") { partialResult, _ in
            partialResult + String(Int.random(in: 1..<10))
        }
    }
}
