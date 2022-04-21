import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: indexHandler)
        routes.get("acronyms", ":acronymID", use: acronymHandler)
        routes.get("users", ":userID", use: userHandler)
    }
    
    func indexHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Acronym.query(on: req.db).all().flatMap { acronyms in
            let context = IndexContext(title: "Homepage", acronyms: acronyms)
            return req.view.render("index", context)
        }
    }
    
    func acronymHandler(_ req: Request) throws -> EventLoopFuture<View> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.$user.get(on: req.db).flatMap { user in
                let context = AcronymContext(title: acronym.long, acronym: acronym, user: user)
                return req.view.render("acronym", context)
            }
        }
    }
    
    func userHandler(_ req: Request) throws -> EventLoopFuture<View> {
        User.find(req.parameters.get("userID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { user in
            user.$acronyms.get(on: req.db).flatMap { acronyms in
                let context = UserContext(title: user.name, user: user, acronyms: acronyms)
                return req.view.render("user", context)
            }
        }
    }
}

struct IndexContext: Encodable {
    let title: String
    let acronyms: [Acronym]
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let user: User
}

struct UserContext: Encodable {
    let title: String
    let user: User
    let acronyms: [Acronym]
}
