import Foundation

struct MagazineMapper: Mapper {
    typealias Entity = MagazineEntity
    typealias Model = Magazine

    static func toEntity(model: Magazine) -> MagazineEntity? {
        return MagazineEntity(
            id: model.id,
            title: model.title,
            issueNumber: model.issueNumber,
            publishDate: model.publishDate,
            creator: model.$creator.value != nil ? MemberMapper.toEntity(model: model.creator) : nil,
            createdAt: model.createdAt ?? Date(),
            updatedAt: model.updatedAt ?? Date()
        )
    }

    static func toModel(entity: MagazineEntity) -> Magazine? {
        guard let creatorId = entity.creator?.id else {
            return nil
        }

        return Magazine(
            id: entity.id,
            title: entity.title,
            issueNumber: entity.issueNumber,
            publishDate: entity.publishDate,
            creatorId: creatorId,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
