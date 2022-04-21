import Vapor
import Foundation

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
    
    app.get("date") { req in
        return "\(Date())"
    }
    
    app.get("counter", ":count") { req -> CountJSON in
        let count = try req.parameters.require("count", as: Int.self)
        return CountJSON(count: count)
    }
    
    app.post("user-info") { req -> String in
        let userInfo = try req.content.decode(UserInfoData.self)
        return "Hello \(userInfo.name), you are \(userInfo.age)!"
    }
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

struct CountJSON: Content {
    let count: Int
}

struct UserInfoData: Content {
    let name: String
    let age: Int
}
