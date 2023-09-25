import SwiftySites

let pageTemplate = Template(exclude: #/^/category/[\W\w]+$|/post|/category|//#) { (page: Page) in baseLayout(page: page, main: """
<main class="page">\(page.content)</main>
""" ) }
