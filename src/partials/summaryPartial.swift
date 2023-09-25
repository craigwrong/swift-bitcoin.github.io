import SwiftySites

let summaryPartial = { (post: Post) -> String in """
<article class="summary">
    <header>
        <p class="date"><a href="\(post.path)">\(post.dateFormatted)</a> • <a href="/category/\(post.category)">\(post.category.name)</a></p>
        <h1 class="title">
            <a href="\(post.path)">\(post.title)</a>
        </h1>
    </header>
    <main>
    \(post.content.split(separator: "\n")[0])
    </main>
</article>
""" }
