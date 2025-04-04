import Fluent
import Vapor

struct ArticleController: RouteCollection {
    let getArticleUsecase: BaseUseCase<GetArticleDTO, ArticleEntity?>
    let getAllArticlesInMagazineUseCase: BaseUseCase<Int, [ArticleEntity]>
    let createMagazineUseCase: BaseUseCase<CreateArticleDTO, ArticleEntity>

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let articles = routes
            .grouped(MemberAuthenticator())
            .grouped("articles")

        articles.post(use: self.create)
        articles.get(use: self.getAll)

        articles.group(":id") { article in
            article.get(use: self.get)
        }
    }

    func get(req: Request) async throws -> BasicResponse<ArticleResponseDTO> {
        guard let idParameter = req.parameters.get("id"),
              let id = Int(idParameter) else {
                throw ControllerError.validationError("id가 필요합니다")
        }
        
        guard let user = req.auth.get(CurrentUser.self) else {
            throw ControllerError.needLoginError
        }

        if let articleEntity = try await getArticleUsecase.execute(GetArticleDTO(articleId: id, requestedBy: user), on: req.db) {
            let responseDTO = ArticleResponseDTO.from(entity: articleEntity, includeContent: true)
            if responseDTO == nil {
                throw ControllerError.convertDTOFailedError("magazine DTO 변환에 실패했습니다")
            }
            return BasicResponse.okay(data: responseDTO)
        }
        
        return BasicResponse.notFound()
    }

    func create(req: Request) async throws -> BasicResponse<ArticleEntity> {
        let dto = try req.content.decode(CreateArticleDTO.self)
        let magazine = try await createMagazineUseCase.execute(dto, on: req.db)
        return BasicResponse.okay(data: magazine)
    }

    func getAll(req: Request) async throws -> BasicResponse<[ArticleResponseDTO]> {
        if let issueNumber: Int = req.query["issueNumber"] {
            return try await getAllInMagazine(issueNumber: issueNumber, db: req.db) 
        }

        return BasicResponse.okay(data: [])
    }

    func getAllInMagazine(issueNumber: Int, db: any Database) async throws -> BasicResponse<[ArticleResponseDTO]> {
        let articleEntities = try await getAllArticlesInMagazineUseCase.execute(issueNumber, on: db)
        let responseDTOList = articleEntities.compactMap { ArticleResponseDTO.from(entity: $0, includeContent: false) }
        return BasicResponse.okay(data: responseDTOList)
    }
}
