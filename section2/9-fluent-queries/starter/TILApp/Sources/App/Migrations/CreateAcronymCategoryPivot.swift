import Fluent

struct CreateAcronymCategoryPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronym-category-pivot")
            .id()
            .field("acronymID", .uuid, .required, .references("acronyms", "id", onDelete: .cascade))
            .field("categoryID", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronym-category-pivot")
            .delete()
    }
}
