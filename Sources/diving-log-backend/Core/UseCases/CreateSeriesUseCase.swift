import Fluent
import Foundation

final class CreateSeriesUseCase: BaseUseCase<CreateSeriesDTO, SeriesEntity>, @unchecked Sendable {
    private let repository: any SeriesRepositoryProtocol

    init(repository: any SeriesRepositoryProtocol) {
        self.repository = repository
    }

    override func execute(_ input: CreateSeriesDTO, on db: (any Database)?) async throws -> SeriesEntity {
        guard let db = db else {
            throw DomainError.internalError("서버 내부 문제가 발생했습니다 (db should not be nil)")
        }

        do {
            let entity = SeriesEntity(
                id: nil,
                title: input.title,
                description: input.description,
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
        } catch let error as RepositoryError {
            throw DomainError.databaseError(error.localizedDescription)
        }
    }
}
