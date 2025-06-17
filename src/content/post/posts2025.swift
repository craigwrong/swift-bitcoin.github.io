let post12 = Post("/post/2025-06-17-start-testnet4-effort", "Start of Testnet 4 Compatibility Effort", "2025-06-17T12:00:00Z", .announcements) { """
Testnet compatibility is a mandatory milestone for any piece of Bitcoin-related software aiming to eventually reach production stage.

It's also great timing that the old testnet 3 network is being decommissioned in favor of a more robust version 4.

As of the start of this week the primary objective of the Swift Bitcoin project will be to support Testnet 4. This includes connecting to nodes and sync'ing the blockchain, as well as compatibility with all preexisting functionality like wallet and PSBT.

The completion of this phase will likely justify the release of the first beta. We have set a deadline of 6 months to try to get there with as much quality as possible.

Stay tuned for more announcements regarding this effort, coming soon.
""" }

let post11 = Post("/post/2025-06-13-psbt", "Partially Signed Bitcoin Transactions", "2025-06-13T12:00:00Z", .specification) { """

PSBT support as defined by BIP174 is an important feature to have for any Bitcoin SDK. It serves as a compatibility layer between different software implementations as well as dedicated hardware devices such as wallets and signers.

While we hesitated at first to include this feature before Swift Bitcoin 0.1.0 is even out, a consideration was made that it would put the entire framework to the test – in a good way.

Given that PSBTs cover the entire lifecycle of a Bitcoin transaction it serves as validation that creation and signing flows can be built on top of the wallet API.

So far most of the effort was concentrated in passing the BIP's official test vectors. This ensures correct parsing and serialization as well as verifying preconditions for each role: creator, updater, signer, combiner, finalizer and extractor.

There's still room for improvement – specially on the ergonomics of the public interface – but the main functionality is already present.

```swift
import BitcoinPSBT

// Creator
// `tx` is a multisig transaction with with P2SH and P2SH-P2WSH inputs and 2 outputs.
var psbt = try PartiallySignedTx(tx) // Create from unsigned transaction
let psbtData = psbt.data // Serialize to pass it around

// Updater 1
psbt = try PartiallySignedTx(psbtData) // Parse from serialized format
psbt.update(input: 0, fund1)
psbt.update(input: 0, redeemScript: redeem0)
psbt.update(input: 0, pubkey0, path0)
psbt.update(input: 0, pubkey1, path1)

psbt.update(input: 1, fund0.outs[1])
psbt.update(input: 1, redeemScript: redeem1)
psbt.update(input: 1, witnessScript: witness)
psbt.update(input: 1, pubkey2, path2)
psbt.update(input: 1, pubkey3, path3)

psbt.update(out: 0, pubkey4, path4)
psbt.update(out: 1, pubkey5, path5)

let psbtData1 = psbt.data

// Second updater
psbt = try PartiallySignedTx(psbtData1)
psbt.update(input: 0, SighashType.all)
psbt.update(input: 1, SighashType.all)
let psbtData = psbt.data2

// Signer
psbt = try PartiallySignedTx(psbtData2)
try psbt.sign(input: 0, using: secretKey0)
try psbt.sign(input: 1, using: secretKey1)
let psbtData3 = psbt.data

// Second signer
psbt = try PartiallySignedTx(psbtData3)
try psbt.sign(input: 0, using: secretKey0)
try psbt.sign(input: 1, using: secretKey1)
let psbtData4 = psbt.data

// Combiner
psbt = try PartiallySignedTx(psbtData4)
psbt.combine(with: psbt2)
let psbtData5 = psbt.data

// Finalizer
psbt = try PartiallySignedTx(psbtData5)
psbt.finalize()
let psbtData6 = psbt.data

// Extractor
psbt = try PartiallySignedTx(psbtData6)
let tx = psbt.extractTx()

// Assuming we have a configured node.
…
node.sendTransaction(tx) // Broadcast signed transaction
```
""" }

let post10 = Post("/post/2025-04-24-node-config-swift", "Node Configuration in Swift", "2025-04-24T12:00:00Z", .implementation) { """

A cool feature of the Swift Package Manager (SPM) is how its package manifest format is itself part of the Swift Language. This is easier before compilation when the project's source code and the Swift compiler are at hand but can that approach be extended for compiled tools like `bcnode`?

We accepted the challenge as it would be fitting for our product to have its configuration optionally specified in Swift. This of course will only be possible if the Swift Runtime is installed on the user's system which is why we'll also allow JSON5 versions of the configuration file.

Actually why not make the JSON format precisely match the serialization of the Swift Bitcoin configuration format in Swift? This way we can decode a JSON configuration and get the internal representation which we can work with directly in our source code. Conversely, if we take a `config.swift` file and serialize the object defined inside, we will end up with the JSON version of the same parameters.

So how can we achieve this versatility? Swift can act as both a compiled or an interpreted language which definitely can come in handy. One thing it cannot do though is evaluate Swift code from within a compiled program so we need to be creative. Our solution involves reading the configuration file containing a variable declaration. We will prepend that declaration with the necessary type definition.

The end result is a pure Swift configuration file that could look like this:

```swift
let feeRate = 100
let config = NodeConfig(
    name: "My Node with fee rate of \\(feeRate)",
    feeRate: feeRate
    …
}
```
""" }

let post09 = Post("/post/2025-03-21-miniscript-dsl", "Miniscript DSL", "2025-03-21T12:00:00Z", .specification) { """

One of the superpowers of Swift is the ability to define Domain Specific Languages (DSL) directly over the type system. That presented a great opportunity to have Bitcoin [Miniscript](https://bitcoin.sipa.be/miniscript/) implemented as a [Swift DSL](https://developer.apple.com/videos/play/wwdc2021/10253) and have the compiler check its syntax entirely.

On its face Miniscript has a very straightforward syntax: fragments use a `fragment(arguments,...)` notation while wrappers are written using prefixes separated from other fragments by a colon. The colon is dropped between subsequent wrappers for instance in `dv:older(144)` the `d:` wrapper applied to the `v:` wrapper applied to the `older` fragment for `144` blocks.

Aside from mapping the Miniscript format closely to something that the Swift Compiler can understand we face additional challenges. While the language is designed to be composable not all expressions are mutually compatible. There's four basic expression types: base (B), verify, (V) key (K) and wrapped (W). There's also five independent type modifiers: zero-arg (z), one-arg (o), non-zero (n), dissatisfiable (d) and unit (u) for additional guaranties.

To model this we created two sets of protocols: one for expression types and an orthogonal one for modifiers. Also we included some aggregate protocols for cases where either one type or another was required by the fragment. Finally the top level protocol `MiniscriptExp` represents the all-important capability of being able to emit (transpile into) actual Bitcoin SCRIPT directly from a Miniscript program.

```swift
public protocol MiniscriptExp {
    var compiled: [ScriptOp] { get }
}

/// B, K or V
public protocol ExpBKV: MiniscriptExp { }

public protocol ExpB: ExpBKV { }

public protocol ModZ: MiniscriptExp { }
…
```

This allows us to specify exactly which type of expression we will construct and which type a particular fragment requires as argument. Even cases where an optional trait of an argument has an effect on the output's modifiers can be modeled.

```swift
public struct Older: ExpB, ModZ {
    let n: Int

    public var compiled: [ScriptOp] {
        [.encodeMinimally(n), .checkSequenceVerify]
    }
}

public struct OrB<X: ExpB & ModD, Z: ExpW & ModD>: ExpB, ModD, ModU { … }

public struct AndOr<X: ExpB, Y: ExpBKV, Z: ExpBKV>: ExpBKV { … }

extension AndOr: ModZ where X: ModZ, Y: ModZ, Z: ModZ { }
…
```

For the case of wrappers we'll make use of Swift operator overload feature. Unfortunately the semi-colon is not a valid identifier so we used `~` instead. To group valid combinations of nested wrappers together we'll just generate functions for each of them. It ends up reading somewhat cryptic but all of this complexity will be hidden from the smart contract programmer.

```swift
public func ~<X: ExpB>(lhs: @escaping (_ x: X) -> U_<X>, rhs: X) -> U_<X> { lhs(rhs) }
public func U<X: ExpB>(_ x: X) -> U_<X> { U_(x) }
public struct U_<X: ExpB>: ExpB, ModD {

public func ~<X: ExpB>(lhs: @escaping (_ x: X) -> S_<L_<N_<X>>>, rhs: X) -> S_<L_<N_<X>>> { lhs(rhs) }
public func SLN<X: ExpB>(_ x: X) -> S_<L_<N_<X>>> { S_(L_(N_(x))) }
```

And with all that the finally result is one of an uncanny resemblance between the original Miniscript source and the DSL version of it. Take a look at this [example](https://github.com/swift-bitcoin/swift-bitcoin/blob/develop/test/bitcoin-miniscript/Miniscript.swift) from the specification:

```swift
// thresh(3,pk(key1),s:pk(key2),s:pk(key3),sln:older(12960))

Thresh(3, PK(key1), S~PK(key2), S~PK(key3), SLN~Older(12960))
```

From writing the policy like the one above directly in Swift we get full type checking at compile time and the ability to execute without the need for parsing.

The [Bitcoin Miniscript](https://swiftbitcoin.org/docs/miniscript/documentation/bitcoinminiscript/) DSL will be part of the initial release of Swift Bitcoin and can be tested right now.

PS: If you'd like to help enhance the current solution there's an open discussion on the [Swift Forums](https://forums.swift.org/t/miniscript-dsl-implementation-how-to-simplify-complex-solution/78684) which shares some of the challenges faced and how we worked around them in a less-than-ideal fashion.
""" }

let post08 = Post("/post/2025-01-28-improved-docs-generation", "Improved Docs Generation", "2025-01-28T12:00:00Z", .housekeeping) { """

The [/docs](https://swift-bitcoin.github.io/docs) subfolder on this site is now generated independently from the [main repo](https://github.com/swift-bitcoin/swift-bitcoin) which means more frequent updates and accuracy in regards to the actual source code.

Since the site is generated with Swift using [SwiftySites](https://github.com/swiftysites/swiftysites) it made sense to build the site and the DocC documentation in one go. But this requires the entire documentation site to be placed inside the _static_ folder of the statically generated site which is checked under version control.

With the new architecture the DocC script is run independently and its results deployed straight to the _docs_ subfolder leaving the rest of the site unaffected. Similarly when a new blog post is published the documentation stays intact.

The entire automation is orchestrated with GitHub Actions and GitHub Pages. To achieve the subfolder behavior the main site is hosted directly under the GitHub organization while the [Docs](https://github.com/swift-bitcoin/docs/actions/workflows/docs.yml) repository does the heavy lifting of producing the documentation site and deploying it to its own GitHub Page which is automatically linked to the subfolder.

It is not possible for an action running out of the Swift Bitcoin repository to deploy to a different Pages URL. So the trick here is to use a dedicated docs repo and within the workflow checkout a different repository – in this case `swift-bitcoin`.

```yaml
…
# Build documentation job
build:
runs-on: ubuntu-latest
steps:
  - name: Checkout
    uses: actions/checkout@v4
    with:
      repository: swift-bitcoin/swift-bitcoin
…

# Deployment job
deploy:
environment:
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
runs-on: ubuntu-latest
needs: build
steps:
  - name: Deploy to GitHub Pages
    id: deployment
    uses: actions/deploy-pages@v4
```

For more details check out the workflow's [source](https://github.com/swift-bitcoin/docs/blob/release/.github/workflows/docs.yml). Swift Bitcoin's website and docs is completely open source.

Hopefully this change will lead to better quality documentation.
""" }

let post07 = Post("/post/2025-01-27-new-binarycodable-framework", "New BinaryCodable Framework", "2025-01-27T12:00:00Z", .implementation) { """

The new [BinaryCodable](/docs/crypto/documentation/bitcoincrypto/binarycodable) framework adds simplicity, performance and stability to the way Bitcoin types are parsed and serialized from binary streams.

The idea of a `BinaryCodable` protocol is inspired by Swift's own `Codable` protocol. While it is possible to encode/decode binary formats using Apple's framework, the requirement to define keys for all fields hints at a different use case.

To make a type binary decodable just define an initializer:

```swift
init(from decoder: inout BinaryDecoder) throws(BinaryDecodingError)
```

Use `BinaryDecoder` to decode each field, like in the case of a non-witness Bitcoin transaction:

```swift
version = try decoder.decode()
ins = try decoder.decode()
outs = try decoder.decode()
locktime = try decoder.decode()
```

To encode simply implement the `encode(to:)` method and use the provided `BinaryEncoder` instance to encode each value.

```swift
public func encode(to encoder: inout BinaryEncoder) {
    encoder.encode(version)
    encoder.encode(ins)
    encoder.encode(outs)
    encoder.encode(locktime)
}
```

Notice how because `TxIn` and `TxOut` are themselves binary codable, a collection of inputs and outputs can be trivially handled by the encoder and decoder. The framework is tailored for Bitcoin development so the variable integer prefix is handled automatically.

This will greatly improve all serialization logic across the Swift Bitcoin codebase both in readability as well as speed.

The Binary Codable API is public so you can also use it independently by simply importing `BitcoinCrypto`.

""" }

let post06 = Post("/post/2025-01-16-testing-transport-layer", "Testing the Transport Layer", "2025-01-16T12:00:00Z", .testing) { """

Creating meaningful unit tests can be difficult – even more when the system under test is a transport layer protocol like the [Bitcoin wire protocol](https://en.bitcoin.it/wiki/Protocol_documentation).

A modern framework like [Swift Testing](https://developer.apple.com/documentation/testing/) offers facilities to deal with asynchronous code. We are taking full advantage of that capability to verify node interactions like the [handshake sequence](https://developer.bitcoin.org/reference/p2p_networking.html#version), post handshake exchange, ping/pong and transaction and block relay communication.


As an example let's look at how Alice would relay a transaction to Bob.

First let's define our services get a reference to some channels:

```swift
import Bitcoin

let alice = NodeService(blockchain: BlockchainService())
let bob = NodeService(blockchain: BlockchainService())

// Alice's asynchronous messages to Bob.
var aliceToBob = await alice.getChannel(for: peerB).makeAsyncIterator()

// Alice's transaction inventory (subscription to internal blockchain events).
var aliceTxs = try #require(await alice.txs?.makeAsyncIterator())

```

After bootstrapping our nodes with a synchronized state we can kickstart an interaction by submitting a new transaction to Alice's mempool:

```swift
let tx = …

// Add the transaction directly to Alice's blockchain as one would with RPC.
Task {
    try await alice.blockchain.addTx(tx)
}

// Alice's transactions channel will notify us of the newly accepted transaction.
let aliceTx = try #require(await aliceTxs.next())
await Task.yield()

// We can now forward the transaction to the node so that it can relay it to its peers if needed.
Task {
    await alice.handleTx(aliceTx)
}
```

We can see how a combination of subtasks and `Task.yield()` can help us work through the asynchronicity.

Once the transaction relay process is triggered we proceed to checking the actual message exchange:

```swift
// Alice --(inv)->> …
let messageAB0_inv = try #require(await aliceToBob.next())
await Task.yield()
#expect(messageAB0_inv.command == .inv)

let inv = try #require(InventoryMessage(messageAB0_inv.payload))
#expect(inv.items == [.init(type: .witnessTx, hash: tx.id)])

// … --(inv)->> Bob
try await bob.processMessage(messageAB0_inv, from: peerA)

// Bob --(getdata)->> …
let messageBA0_getdata = try #require(await bob.popMessage(peerA))
#expect(messageBA0_getdata.command == .getdata)

let getData = try #require(GetDataMessage(messageBA0_getdata.payload))
#expect(getData.items == [.init(type: .witnessTx, hash: tx.id)])

// … --(getdata)->> Alice
try await alice.processMessage(messageBA0_getdata, from: peerB)

// Alice --(tx)->> …
let messageAB1_tx = try #require(await alice.popMessage(peerB))
#expect(messageAB1_tx.command == .tx)

let txMessage = try #require(BitcoinTx(messageAB1_tx.payload))
#expect(txMessage == tx)

// … --(tx)->> Bob
try await bob.processMessage(messageAB1_tx, from: peerA)
```

As indicated by the comments in the snippet above the sequence of messages being verified looks like:

- Alice sends an `inv` message to Bob.
- Bob responds to Alice with a `getdata` message.
- Alice responds to Bob with a `tx` message.

In addition to inspecting each message's content along the way we can also ensure the state of the node and blockchain services is correct. For instance here's how we would compare the mempool's content to our expectation of it containing our relay transaction:

```swift
let bobsMempool = await bob.blockchain.mempool
#expect(await alice.blockchain.mempool == bobsMempool)
```

That's it. Check out the rest of Swift Bitcoin [Transport tests](https://github.com/swift-bitcoin/swift-bitcoin/tree/develop/test/bitcoin-transport) and feel free to reach out if you would like to contribute!
""" }

let post05 = Post("/post/2025-01-03-update", "New Year's Update", "2025-01-03T12:00:00Z", .announcements) { """

Happy 2025 to all Swift and Bitcoin devs! And Happy 16th Birthday to the Bitcoin network! I wanted to use the occasion for posting an update of where the project stands today and where it could go from here.

Swift Bitcoin is still in pre-release phase so its API cannot be considered stable. The crypto, base and wallet modules are quite mature at this point. Most of the foundational BIPs in this area have been implemented and tested using the official vectors and cases ported from Bitcoin Core. Other areas like the blockchain and the transport layer still need some work and are currently under heavy development.

In summary you can use the Swift Bitcoin library today to:

- Construct a Bitcoin transaction from scratch.
- Configure transaction inputs by referencing outpoints to previous transactions.
- Set up standard transaction outputs of different kinds: legacy p2pk, p2pkh, p2sh, multisig, segwit, taproot, tapscript.
- Parse or produce all types of bitcoin addresses and use them to specify transaction outputs.
- Create custom scripts, test-run them and codify them into outputs or tapscript trees.
- Sign transaction inputs using secret keys.
- Check and verify transactions in isolation.
- Derive keys from extended private/public keys.
- Derive keys from mnemonic phrases in several languages (with optional passphrase).
- Manipulate different types of public key formats (compressed, compact) and signatures (ECDSA, Schnorr).
- Apply any of the hashing functions used in Bitcoin: RIPEMD160, SipHash, Hash256, Hash160, PBKDF2, SHA1, SHA256, SHA512, HMAC, Tagged SHA256
- Encode and decode raw data using Base16, Base58(check), Bech32(n)
- Serialize/deserialize Bitcoin transactions, scripts and blocks.
- Add new transactions to the mempool.
- Generate new blocks with transactions from the mempool.
- Subscribe to notifications (blocks and transactions) from the blockchain service.
- Create node instances on the fly and interconnect network peers.
- Craft or inspect wire protocol messages which can be intercepted / re-routed.
- Launch an RPC server and invoke RPC commands.

In addition you can perform off-chain operations by operating the Bitcoin Utility (bcutil) command line tool. The same command also controls full node instances launched by `bcnode` by sending them RPC commands.

The Bitcoin Node currently only supports in-memory regtest data and offers no persistence.

So for this year the main high level goals for the project could be defined as:

- Completion of the wire protocol functionality with additional unit tests.
- Finish and improve UTXO set management.
- Release of version 0.1 with minimized API breaking changes.
- Testnet3/testnet4 synchronization.
- Persistence of block data on disk using the file system.

So here's to a 2025 full of Bitcoin greatness and with a pure Swift client implementation closer to reality.

Cheers!
""" }
