import SwiftySites

extension Page {
    var category: Category {
        let components = path.split(separator: "/")
        let categoryID = String(components.last!)
        return Category(rawValue: categoryID)!
    }
}
