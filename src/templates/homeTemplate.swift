import SwiftySites

let homeTemplate = Template(#///#) { (page: Page) in baseLayout(page: page, main: """
<main class="home">
    <section class="intro">
        \(page.content)
    </section>
    <section>
        <h1>Latest Posts</h1>
        \(posts.sorted(by: Post.dateDescendingOrder).enumerated().map {
            """
            \(summaryPartial($1))
            \($0 < posts.count - 1 ? "<hr />" : "")
            """
        }.joined())
    </section>
</main>
""" ) }
