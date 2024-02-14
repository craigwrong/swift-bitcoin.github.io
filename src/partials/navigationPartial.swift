import SwiftySites

let navigationPartial = { (page: Page?) -> String in """
<nav>
    <ul>
        \([pageHome, pageInfo].reduce("") {
            $0 + """
            <li>\(page?.path == $1.path
                ? """
                \($1.title)
                """
                : """
                <a href="\($1.path)">\($1.title)</a>
                """
            )</li>
            """
        })
        <li>
            <a href="/docc/documentation/bitcoin/">Docs</a>
        </li>
        \(/* External link */"")<li>
            <a href="https://github.com/swift-bitcoin/swift-bitcoin">Code</a>
        </li>
    </ul>
</nav>
""" }
