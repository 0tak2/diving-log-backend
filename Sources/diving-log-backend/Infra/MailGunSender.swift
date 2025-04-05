//
//  MailGunSender.swift
//  diving-log-backend
//
//  Created by 임영택 on 4/5/25.
//

import Foundation

final class MailGunSender: EmailSendable {
    private let mailGunApiKey: String
    private let mailSendBy: String
    private let mailDomain: String
    
    init(mailGunApiKey: String, mailSendBy: String, mailDomain: String) {
        self.mailGunApiKey = mailGunApiKey
        self.mailSendBy = mailSendBy
        self.mailDomain = mailDomain
    }
    
    func send(nameTo name: String, emailTo email: String, subject: String, body: String) async throws {
        try await requestSendEmail(nameTo: name, emailTo: email, subject: subject, body: body)
    }
    
    private func requestSendEmail(nameTo name: String, emailTo email: String, subject: String, body: String) async throws {
        // MARK: MailGun
        let apiKey = self.mailGunApiKey
        let domain = self.mailDomain
        let requestEndPoint = "https://api.mailgun.net/v3/\(domain)/messages"

        guard let url = URL(string: requestEndPoint) else {
            throw InfraError.validationError("API 엔드포인트가 잘못되었습니다")
        }

        // MARK: Make request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loginString = "api:\(apiKey)"
        guard let loginData = loginString.data(using: .utf8) else {
            throw InfraError.internalError("loginData should not be nil")
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        // MARK: Form data
        let bodyParams: [String: String] = [
            "from": "\(mailSendBy) <admin@\(domain)>",
            "to": "\(name) <\(email)>",
            "subject": subject,
            "text": body
        ]
        let bodyString = bodyParams.map { "\($0)=\($1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                                   .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw InfraError.thirdPartyError("메일 서버 응답이 잘못되었습니다")
            }
            
            if httpResponse.statusCode != 200 {
                throw InfraError.thirdPartyError("메일 전송에 실패했습니다")
            }
        } catch let error as InfraError {
            throw error
        } catch {
            CustomLoggerProvider.of("MailGunSender").error("\(error)")
            throw InfraError.internalError(error.localizedDescription)
        }
    }
}
