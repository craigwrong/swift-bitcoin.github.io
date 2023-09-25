import Foundation
import SwiftySites

struct Post: Content {
    let path: String
    let title: String
    let date: Date
    let category: Category
    let tweet: String?

    @Markdown private(set) var content: String

    init(
        _ path: String,
        _ title: String,
        _ date: String,
        _ category: Category,
        _ tweet: String? = .none,
        content: () -> String
    ) {
        self.path = path
        self.title = title
        guard let date = ISO8601DateFormatter().date(from: date) else {
            fatalError("Please use ISO8601 format for dates. Example, '2021-08-15T12:33:00Z'.")
        }
        self.date = date
        self.category = category
        self.tweet = tweet
        self.content = content()
    }

    var dateFormatted: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateStyle = .medium
        return df.string(from: date)
    }

    var dateRssFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        return dateFormatter.string(from: date) // // Mon, 02 Jan 2006 15:04:05 -0700
    }

    static func dateDescendingOrder(_ l: Post, _ r: Post) -> Bool {
        l.date > r.date
    }
}
