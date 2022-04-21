import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("hello", "vapor") { req in
        "Hello Vapor!"
    }
    
    app.get("hello", ":name") { req -> String in
        let name = try req.parameters.require("name", as: String.self)
        return "Hello \(name)"
    }
    
    app.post("info") { req -> InfoResponse in
        let data = try req.content.decode(InfoData.self)
        return InfoResponse(request: data)
    }
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}
