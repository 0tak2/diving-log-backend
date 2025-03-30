import Foundation

struct ArticleMapper: Mapper {
    typealias Entity = ArticleEntity
    typealias Model = Article

    static func toEntity(model: Article) -> ArticleEntity? {
        ArticleEntity(
            id: model.id, 
            title: model.title, 
            editor: model.$editor.value != nil ? MemberMapper.toEntity(model: model.editor) : nil,
            magazine: model.$magazine.value != nil ? MagazineMapper.toEntity(model: model.magazine) : nil, 
            order: model.order, 
            series: model.$series.value != nil ? SeriesMapper.toEntity(model: model.series) : nil, 
            content: model.content, 
            contentType: ArticleEntity.ContentType(rawValue: model.contentType.rawValue) ?? .md, 
            contentUrl: model.contentUrl, 
            isDeleted: model.isDeleted, 
            accessibleLevel: model.accessibleLevel, 
            createdAt: model.createdAt ?? Date(), 
            updatedAt: model.updatedAt ?? Date()
        )
    }

    static func toModel(entity: ArticleEntity) -> Article? {
        guard let editorId = entity.editor?.id,
              let magazineId = entity.magazine?.id,
              let seriesId = entity.series?.id else {
            return nil
        }

        return .init(
            id: entity.id, 
            title: entity.title, 
            editorId: editorId, 
            magazineId: magazineId, 
            seriesId: seriesId, 
            content: entity.content, 
            contentType: Article.ContentType(rawValue: entity.contentType.rawValue) ?? .md, 
            contentUrl: entity.contentUrl,
            accessibleLevel: entity.accessibleLevel, 
            isDeleted: entity.isDeleted,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
