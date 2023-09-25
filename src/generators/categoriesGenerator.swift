import SwiftySites

let categories = Category.allCases.map { category in Page("/category/\(category)", "\(category.name)") { """
    # \(category.name) Category
    
    Posts on the _\(category.name)_ category.
    
    """ } }
