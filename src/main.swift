import SwiftySites

let posts = [
    postIntroducingSwiftBitcoinLibrary,
]

let site = Site(
    config,
    content: (
        [pageHome, pageAbout, pageCategories],
        posts,
        categories
    ),
    template: (
        [pageTemplate, homeTemplate, categoriesTemplate],
        [postTemplate],
        [categoryTemplate]
    )
)

site.render()
