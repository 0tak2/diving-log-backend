import Vapor

struct ArticleResponseDTO: Content {
    let id: Int?
    let title: String
    let editorNickname: String?
    let editorId: String?
    let magazineIssueNumber: Int?
    let order: Int
    let seriesTitle: String?
    let seriesId: Int?
    let content: String?
    let contentType: ArticleEntity.ContentType
    let contentUrl: String?
    let isDeleted: Bool
    let accessibleLevel: Int
    let createdAt: Date?
    let updatedAt: Date?

    static func from(entity: ArticleEntity, includeContent: Bool) -> ArticleResponseDTO? {
        guard let editor = entity.editor,
            let editorId = editor.id?.uuidString,
            let magazine = entity.magazine,
            let series = entity.series else {
                CustomLoggerProvider.of("ArticleResponseDTO").warning("editor/magazine/series not included in this entity")
                return nil
        }

        return ArticleResponseDTO(
            id: entity.id,
            title: entity.title,
            editorNickname: editor.nickname,
            editorId: editorId,
            magazineIssueNumber: magazine.issueNumber,
            order: entity.order,
            seriesTitle: series.title,
            seriesId: series.id,
            content: includeContent ? entity.content : nil,
            contentType: entity.contentType,
            contentUrl: entity.contentUrl,
            isDeleted: entity.isDeleted,
            accessibleLevel: entity.accessibleLevel,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
