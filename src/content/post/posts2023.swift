let post02 = Post("/post/2023-10-03-swift-bitcoin-roadmap", "Swift Bitcoin Roadmap", "2023-10-03T12:00:00Z", .announcements) { """

The ultimate goal for Swift Bitcoin is to become the most comprehensive SDK for bitcoin in Swift with features like mempool management, block mining and connectivity via the bitcoin protocol.

The library is being written entirely in Swift. Its only dependency is the official [libsecp256k1](https://github.com/bitcoin-core/secp256k1) for ECDSA and [Schnorr](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki) cryptography.

The library aims to provide full support for bitcoin [transactions](https://en.bitcoin.it/wiki/Transaction), [SCRIPT](https://en.bitcoin.it/wiki/Script), [segregated witness](https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki), [taproot](https://github.com/bitcoin/bips/blob/master/bip-0341.mediawiki), [tapscript](https://github.com/bitcoin/bips/blob/master/bip-0342.mediawiki) and more.

# Development Roadmap

We want the library to be fully tested from the beginning. When available we will use test vectors from the BIPs and reference implementations or port tests directly from [Bitcoin Core](https://bitcoincore.org).

This implies a slow and steady progress but the end result will be a secure and robust product on which developers can base their solutions.

Below is a rough roadmap of the order in which features could be integrated.

- Full transaction model with script, lock-time, input sequence and witness.
- Transaction serialization and deserialization.
- SCRIPT interpreter loop.
- Transaction signature hash, signature [signature hash types](https://river.com/learn/terms/s/sighash-flag/) and signature generation (ECDSA).
- [`OP_CHECKSIG`](https://en.bitcoin.it/wiki/OP_CHECKSIG).
- Transaction verifying for Pay-to-Public-Key (`P2PK`) and Pay-to-Public-Key-Hash (`P2PKH`).
- [`OP_RIPEMD160`](https://en.bitcoin.it/wiki/RIPEMD-160), `OP_SHA256`, `OP_HASH256`, `OP_HASH160` and other cryptographic operations.
- `Base58` and [`Base58Check`](https://en.bitcoin.it/wiki/Base58Check_encoding) address encoding/decoding.
- [`OP_CHECKMULTISIG`](https://en.bitcoin.it/wiki/OP_CHECKMULTISIG).
- Transaction verifying [`P2SH`](https://github.com/bitcoin/bips/blob/master/bip-0016.mediawiki).
- [Relative lock-time](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki).
- [`OP_CHECKSEQUENCEVERIFY`](https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki).
- [`OP_CHECKLOCKTIMEVERIFY`](https://github.com/bitcoin/bips/blob/master/bip-0065.mediawiki).
- [`NULLDUMMY`](https://en.bitcoin.it/wiki/BIP_0147).
- Other script operations (arithmetic, stack, …).
- [Segwit](https://github.com/bitcoin/bips/blob/master/bip-0143.mediawiki) transaction verifying `P2WPKH`, `P2WSH`, `P2SH-P2WPKH`, `P2SH-P2WSH`.
- [`Bech32`](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki) address encoding/decoding.
- Transaction Schnorr signature generation.
- Pay-to-Taproot [`P2TR`](https://github.com/bitcoin/bips/blob/master/bip-0086.mediawiki) (key-hash spends only).
- Transaction signing for all standard scripts.
- [`Bech32m`](https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki) address encoding/decoding.
- `OP_CHECKSIGADD` (witness V1 script).
- Tapscript transactions.

""" }

let post01 = Post("/post/2023-07-25-introducing-the-swift-bitcoin-library", "Introducing: The Swift Bitcoin Library", "2023-07-25T12:00:00Z", .announcements) { """

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
