import Vapor

struct ErrorMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch let error as DomainError {
            request.logger.error("responded domain error. message=\(error.errorDescription ?? "")")
            let responseDTO = error.toResponse()
            return try await responseDTO.encodeResponse(status: HTTPStatus(statusCode: responseDTO.status), for: request)
        } catch let error as ControllerError {
            request.logger.error("responded controller error. message=\(error.errorDescription ?? "")")
            let responseDTO = error.toResponse()
            return try await responseDTO.encodeResponse(status: HTTPStatus(statusCode: responseDTO.status), for: request)
        } catch {
            request.logger.error("unexpected error. error=\(String(reflecting: error))")
            let responseDTO = BasicResponse<EmptyType>(status: 500, message: "Internal Server Error", data: nil)
            return try await responseDTO.encodeResponse(status: HTTPStatus(statusCode: responseDTO.status), for: request)
        }
    }
}
