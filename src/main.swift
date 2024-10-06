import SwiftySites

let posts = [
    post01, post02, post03, post04
]

let site = Site(
    config,
    content: (
        [pageHome, pageInfo, pageCategories],
        posts,
        categories
    ),
    template: (
        [pageTemplate, homeTemplate, categoriesTemplate],
        [postTemplate],
        [categoryTemplate]
    )
)

site.render(clean: true)
