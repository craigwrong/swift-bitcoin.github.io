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
