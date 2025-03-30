import Fluent
import Vapor

struct MagazineController: RouteCollection {
    let createMagazineUseCase: BaseUseCase<CreateMagazineDTO, MagazineEntity>

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let magazines = routes.grouped("magazines")

        magazines.post(use: self.create)

        // magazines.group(":id") { magazine in
        //     magazine.get(use: self.get)
        // }
    }

    func create(req: Request) async throws -> BasicResponse<MagazineEntity> {
        let dto = try req.content.decode(CreateMagazineDTO.self)
        let magazine = try await createMagazineUseCase.execute(dto, on: req.db)
        return BasicResponse.okay(data: magazine)
    }
}
