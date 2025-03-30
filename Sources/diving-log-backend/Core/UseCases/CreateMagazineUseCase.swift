import Fluent
import Foundation
import PostgresKit

final class CreateMagazineUseCase: BaseUseCase<CreateMagazineDTO, MagazineEntity>, @unchecked Sendable {
    private let repository: any MagazineRepositoryProtocol

    init(repository: any MagazineRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: CreateMagazineDTO, on db: (any Database)?) async throws -> MagazineEntity {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }

        do {
            return try await db.transaction { db in
                do {
                    let _ = try await self.repository.get(issueNumber: input.issueNumber, on: db)
                    throw DomainError.alreadyExistError("issueNumber \(input.issueNumber)인 magazine은 이미 있습니다")
                } catch let error as DomainError {
                    guard case .notFoundError = error else {
                        throw error
                    }
                }

                let entity = MagazineEntity(
                    id: nil, 
                    title: input.title, 
                    issueNumber: input.issueNumber, 
                    publishDate: input.publishDate, 
                    creator: MemberEntity(
                        id: UUID(uuidString: "ff30a6a6-8a3a-4a7a-911b-a67925f0a6c0"), // FIXME
                        appleOAuthId: "", 
                        nickname: "", 
                        isDeleted: false, 
                        memberLevel: 3, 
                        createdAt: Date(), 
                        updatedAt: Date(), 
                        hasEmailVerified: true, 
                        email: nil
                    ), 
                    createdAt: nil, 
                    updatedAt: nil
                )
                return try await self.repository.create(entity: entity, on: db)
            }
        } catch let error as PSQLError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
