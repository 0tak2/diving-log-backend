import Vapor

struct MagazineReponseDTO: Content {
    let id: Int?
    let title: String
    let issueNumber: Int
    let publishDate: Date
    let creatorNickname: String
    let creatorId: String
    let createdAt: Date?
    let updatedAt: Date?

    static func from(entity: MagazineEntity) -> MagazineReponseDTO? {
        guard let creator = entity.creator,
            let creatorId = creator.id?.uuidString else {
            CustomLoggerProvider.of("MagazineReponseDTO").warning("creator not included in this entity")
            return nil
        }

        return MagazineReponseDTO(
            id: entity.id,
            title: entity.title,
            issueNumber: entity.issueNumber,
            publishDate: entity.publishDate,
            creatorNickname: creator.nickname,
            creatorId: creatorId,
            createdAt: entity.createdAt,
            updatedAt: entity.createdAt
        )
    }
}
