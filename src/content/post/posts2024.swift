let post04 = Post("/post/2024-10-06-update", "October Update", "2024-10-06T12:00:00Z", .announcements) { """

So far this year the focus has shifted a bit from getting the client fluent in the peer-to-peer language protocol to making important refinements to many of the public APIs offered by the package.

# New package organization

Swift Bitcoin is now organized in several discreet modules:

- _Crypto_ – Contains all the elliptic curve cryptography needed as well as indispensable hash functions and encodings.
- _Base_ – Focuses on transaction building and verifying, including a full SCRIPT interpreter.
- _Wallet_ – Adds a layer which includes addresses, key derivation, mnemonics and signing. 
- _Blockchain_ – Exposes services for blocks, mempool and chain state management, complete with a basic mining algorithm.
- _Transport_ – Introduces the notion of network peers and how they communicate using the P2P protocol. 
- _RPC_ – Provides codecs for important remote node commands.

In additions to these libraries, the package delivers two command-line tools:

- _Node_ – Launches an instance of a full node which listens to RPC commands and can speak the wire protocol. 
- _Utility_ – Can be used to control running service instances as well as perform a series of offline operations.

# Improved API examples

As an example of the simplicity of the new APIs here's some code snippets taken from the revamped [documentation](https://swift-bitcoin.github.io/docs/documentation/bitcoin/):

## Running a simple script

Here's how to add two numbers:

```swift
let stack = try BitcoinScript([.constant(1), .constant(1), .add]).run()
#expect(stack.count == 1)
let number = try ScriptNumber(stack[0])
#expect(number.value == 2)
```

## Spending a transaction

This is how Bob would send satoshis to Alice:

```swift
// Bob gets paid.
let bobsSecretKey = SecretKey()
let bobsAddress = BitcoinAddress(bobsSecretKey)

// The funding transaction, sending money to Bob.
let fundingTransaction = BitcoinTransaction(inputs: [.init(outpoint: .coinbase)], outputs: [
    bobsAddress.output(100) // 100 satoshis
])

// Alice generates an address to give Bob.

let alicesSecretKey = SecretKey()
let alicesAddress = BitcoinAddress(alicesSecretKey)

// Bob constructs, sings and broadcasts a transaction which pays Alice at her address.

// The spending transaction by which Bob sends money to Alice
let spendingTransaction = BitcoinTransaction(inputs: [
    .init(outpoint: fundingTransaction.outpoint(0)),
], outputs: [
    alicesAddress.output(50) // 50 satoshis
])

// Sign the spending transaction.
let prevouts = [fundingTransaction.outputs[0]]
let signer = TransactionSigner(
    transaction: spendingTransaction, prevouts: prevouts, sighashType: .all
)
let signedTransaction = signer.sign(input: 0, with: bobsSecretKey)

// Verify transaction signatures.
let result = signedTransaction.verifyScript(prevouts: prevouts)
#expect(result)
```

## Connecting two nodes

Here's how Hal would connect to Satoshi:

```swift
let satoshiChain = BitcoinService()
let publicKey = try #require(PublicKey(compressed: [0x03, …]))
await satoshiChain.generateTo(publicKey)

let satoshi = NodeService(bitcoinService: satoshiChain, feeFilterRate: 2)
let halPeer = await satoshi.addPeer()
var satoshiOut = await satoshi.getChannel(for: halPeer).makeAsyncIterator()

let halChain = BitcoinService()
let hal = NodeService(bitcoinService: halChain, feeFilterRate: 3)
let satoshiPeer = await hal.addPeer(incoming: false)
var halOut = await hal.getChannel(for: satoshiPeer).makeAsyncIterator()

// Perform the wire protocol handshake (simplified)

await hal.connect(satoshiPeer)

// `messageHS0` means "0th Message from Hal to Satoshi".

// Hal --(version)->> …
let messageHS0_version = try #require(await hal.popMessage(satoshiPeer))

// … --(version)->> Satoshi
try await satoshi.processMessage(messageHS0_version, from: halPeer)

// Satoshi --(version)->> …
let messageSH0_version = try #require(await satoshi.popMessage(halPeer))

// Satoshi --(verack)->> …
let messageSH3_verack = try #require(await satoshi.popMessage(halPeer))

// … --(version)->> Hal
try await hal.processMessage(messageSH0_version, from: satoshiPeer)

// … --(verack)->> Hal
try await hal.processMessage(messageSH3_verack, from: satoshiPeer)

// Hal --(verack)->> …
let messageHS3_verack = try #require(await hal.popMessage(satoshiPeer))

// … --(verack)->> Satoshi
try await satoshi.processMessage(messageHS3_verack, from: halPeer)
```

# Next steps

Going forward the priority should be to get the transport layer to perform an initial block download against a running Core regtest instance.

The blockchain component needs to be developed further including all block related BIPs.

Finally even more tests need to be migrated over to increase the reliability of the implementation.
""" }
