import SwiftySites

let pageInfo = Page("/info", "Info") { #"""

# Swift Bitcoin

Swift Bitcoin is both a comprehensive Bitcoin SDK for Swift and a standalone full-featured Bitcoin network client with full node capabilities.

The software package is itself built entirely using The Swift Programming Language with the exception of the Elliptic Curve Cryptography part which is outsourced to [libsecp256k1](https://github.com/bitcoin-core/secp256k1).

The framework which includes many functionally distinct libraries can be used as part of any project targeting UNIX/Linux or Apple Platforms (e.g. iOS). It is primarily intended for Swift development although it can easily be integrated into other CMake-based projects.

While still under development, the goal is to provide an as complete as possible implementation of the Bitcoin protocol and associated BIP documents keeping efficiency and security in mind. Swift Bitcoin aims to give developers and users access to all the features of the Bitcoin ecosystem with modern and ergonomic interface.

# Contact

- Swift Bitcoin on X: [@swiftbitcoinorg](https://x.com/swiftbitcoinorg)
- Open a PR on [GitHub](https://github.com/swift-bitcoin/swift-bitcoin)
- DM the developers on X:
  - [@notcraigwright](https://x.com/notcraigwright)

"""# }
