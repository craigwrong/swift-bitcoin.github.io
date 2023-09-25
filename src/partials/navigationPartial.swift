import SwiftySites

let navigationPartial = { (page: Page?) -> String in """
<nav>
    <ul>
        \([pageHome, pageAbout].reduce("") {
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
    </ul>
</nav>
""" }
