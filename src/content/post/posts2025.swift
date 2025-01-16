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
