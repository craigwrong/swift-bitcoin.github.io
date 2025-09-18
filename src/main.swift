import SwiftySites

let posts = [
    post01, post02, post03, // 2023
    post04, // 2024
    post05, post06, post07, post08, post09, post10, post11, post12, post13, post14 // 2025
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
