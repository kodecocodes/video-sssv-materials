import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
}
