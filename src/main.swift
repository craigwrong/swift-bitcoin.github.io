import SwiftySites

let posts = [
    post01, post02
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
