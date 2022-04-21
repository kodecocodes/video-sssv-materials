import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoutes = routes.grouped("api", "categories")
        categoriesRoutes.post(use: createHandler)
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.get(":categoryID", use: getHandler)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
    }
}
