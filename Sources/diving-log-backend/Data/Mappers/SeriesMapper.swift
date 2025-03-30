import Foundation

struct SeriesMapper: Mapper {
    static func toEntity(model: Series) -> SeriesEntity? {
        return SeriesEntity(
            id: model.id,
            title: model.title,
            description: model.description,
            creator: model.$creator.value != nil ? MemberMapper.toEntity(model: model.creator) : nil,
            createdAt: model.createdAt ?? Date(),
            updatedAt: model.updatedAt ?? Date()
        )
    }
    
    static func toModel(entity: SeriesEntity) -> Series? {
        guard let creatorId = entity.creator?.id else {
            return nil
        }

        let series = Series(
            id: entity.id,
            title: entity.title,
            description: entity.description,
            creatorId: creatorId,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
        
        return series
    }
}
