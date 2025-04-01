import Fluent
import Vapor

struct MagazineController: RouteCollection {
    let createMagazineUseCase: BaseUseCase<CreateMagazineDTO, MagazineEntity>
    let getMagazineUseCase: BaseUseCase<Int, MagazineEntity>

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let magazines = routes.grouped("magazines")

        magazines.post(use: self.create)

        magazines.group(":issueNumber") { magazine in
            magazine.get(use: self.get)
        }
    }

    func create(req: Request) async throws -> BasicResponse<MagazineEntity> {
        let dto = try req.content.decode(CreateMagazineDTO.self)
        let magazine = try await createMagazineUseCase.execute(dto, on: req.db)
        return BasicResponse.okay(data: magazine)
    }

    func get(req: Request) async throws -> BasicResponse<MagazineReponseDTO> {
        guard let issueNumberRaw = req.parameters.get("issueNumber"),
              let issueNumber = Int(issueNumberRaw) else {
                throw ControllerError.validationError("issueNumber가 필요합니다")
        }

        let magazineEntity = try await getMagazineUseCase.execute(issueNumber, on: req.db)
        let responseDTO = MagazineReponseDTO.from(entity: magazineEntity)
        if responseDTO == nil {
            throw ControllerError.convertDTOFailedError("magazine DTO 변환에 실패했습니다")
        }
        return BasicResponse.okay(data: responseDTO)
    }
}
