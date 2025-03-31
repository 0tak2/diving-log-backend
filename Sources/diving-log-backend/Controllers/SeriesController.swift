import Fluent
import Vapor

struct SeriesController: RouteCollection {
    let createSeriesUseCase: BaseUseCase<CreateSeriesDTO, SeriesEntity>

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let series = routes.grouped("series")

        series.post(use: self.create)
    }

    func create(req: Request) async throws -> BasicResponse<SeriesEntity> {
        let dto = try req.content.decode(CreateSeriesDTO.self)
        let series = try await createSeriesUseCase.execute(dto, on: req.db)
        return BasicResponse.okay(data: series)
    }
}
