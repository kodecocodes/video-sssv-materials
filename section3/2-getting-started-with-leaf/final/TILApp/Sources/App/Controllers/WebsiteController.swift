import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: indexHandler)
    }
    
    func indexHandler(_ req: Request) throws -> EventLoopFuture<View> {
        let context = IndexContext(title: "Homepage")
        return req.view.render("index", context)
    }
}

struct IndexContext: Encodable {
    let title: String
}
