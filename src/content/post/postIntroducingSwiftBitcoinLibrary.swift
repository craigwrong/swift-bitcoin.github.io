let postIntroducingSwiftBitcoinLibrary = Post("/post/2023-07-25-introducing-the-swift-bitcoin-library", "Introducing: The Swift Bitcoin Library", "2023-07-25T12:00:00Z", .announcements) { """

[Swift Bitcoin](https://github.com/swift-bitcoin/swift-bitcoin) aka _The Swift Bitcoin Library_ is a new project intended for Swift developers who want to build a bitcoin product.

# Apple Platforms

Being the language of the App Store it should come as a surprise that xOS bitcoin apps need to rely on non-Swift libraries for their implementation.

# Server Side

With first-class support for actors and structured concurrency, open-source Swift is more than suitable for building services like full nodes or desktop wallets. Whether running on Linux or on the Mac, a pure Swift package with virtually no additional dependencies is the ideal foundation for green-field software development.

# Bitcoin Core Cryptography

Good bitcoin devs know not to roll their own crypto. That is why Swift Bitcoin leverages the power of Core's `secp256k` library. Thanks to Swift's best-in-class C and C++ interoperability, this integrations is as tight as it can be, leaving no room for devastating errors.

# Development

While the efforts to build out the library are ongoing, a great deal of research has already taken place over the past 12 months. The focus will now switch to ensuring a clear, idiomatic API along with accurate and complete DocC documentation as well as full unit test quality coverage. I will personally do my best to develop the library in the open while accepting help from knowledgable plebs.

""" }
