import SwiftySites

let postTemplate = Template { (post: Post) in baseLayout(post: post, main: """
<main class="post"><article>
    <header>
        <p class="date">\(post.dateFormatted) • <a href="/category/\(post.category)">\(post.category.name)</a></p>
        <h1 class="title">
            \(post.title)
        </h1>
    </header>
    <main>
    \(post.content)
    </main>
    \(
        post.tweet == .none
        ? ""
        : """
        <footer>
            <hr />
            <p>Discuss this post <a href="https://twitter.com/notcraigwright/status/\(post.tweet!)">on Twitter</a>.</p>
        </footer>
        """
    )
</article></main>
""" ) }
