import SwiftySites

let categoryTemplate = Template(#//category/[\W\w]+/#) { (page: Page) in baseLayout(page: page, main: """
<main class="category">
    <div>\(page.content)</div>
    <div>
        <a href="/category">All categories</a>
    </div>
    <br />
    <section>
        \(posts
            .filter { $0.category == page.category }
            .sorted(by: Post.dateDescendingOrder).enumerated().map { """
                \(summaryPartial($1))
                \($0 < posts.count - 1 ? "<hr />" : "")
            """ }
            .joined()
        )
    </section>
</main>
""" ) }
