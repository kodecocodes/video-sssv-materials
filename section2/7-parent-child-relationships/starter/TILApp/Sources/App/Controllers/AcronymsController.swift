import Vapor

struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms")
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(":acronymID", use: getHandler)
        acronymsRoutes.delete(":acronymID", use: deleteHandler)
        acronymsRoutes.put(":acronymID", use: updateHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req.db).map { acronym }
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.delete(on: req.db).transform(to: .noContent)
        }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.short = updatedAcronym.short
            acronym.long = updatedAcronym.long
            return acronym.save(on: req.db).map {
                acronym
            }
        }
    }
}
