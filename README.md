# ⚡ PayLinq — USDC Payment Links on Arc

**Create a payment link. Share it anywhere. Get paid in under a second.**

PayLinq is a dApp built on [Arc](https://docs.arc.io) — Circle's Layer-1 blockchain for programmable money — that lets anyone create shareable USDC payment links and invoices. The payer opens the link, clicks once, and the payment settles onchain with sub-second finality.

🔗 **Live demo:** https://paylinq-beta.vercel.app

---

## ✨ Features

- **One-click payments** — payer connects MetaMask and pays in a single click; Arc Testnet is added to the wallet automatically
- **Onchain by design** — every payment is routed through the verified `PayLinqRouter` contract, which records payer, recipient, amount, and invoice memo permanently onchain
- **Invoice status detection** — payment links automatically show "already paid" by reading `PaymentSent` events from the contract
- **Public onchain traction** — the contract exposes `totalPayments` and `totalVolume` counters; the homepage displays them live
- **QR code for every link** — print it, share it, embed it in an invoice
- **Zero backend** — the entire app is a single static HTML file; invoice data is encoded in the URL itself. No server, no database, no signup

## 🏗 How it works

```
Merchant                    Payer                        Arc (onchain)
   │                          │                              │
   │ 1. Create link           │                              │
   │    (to, amount, memo     │                              │
   │     encoded in URL)      │                              │
   │ ────── share link ─────▶ │                              │
   │                          │ 2. Open link, click Pay      │
   │                          │ ──── pay(recipient, memo) ──▶│
   │                          │      + native USDC value     │
   │                          │                              │ 3. PayLinqRouter forwards
   │                          │                              │    USDC to recipient &
   │                          │                              │    emits PaymentSent event
   │ ◀──────── USDC settles to merchant wallet (<1s) ────────│
```

## 📜 Smart contract

| | |
|---|---|
| Contract | `PayLinqRouter` — [source](./PayLinqRouter.sol) |
| Address (Arc Testnet) | [`0x8e9367F710684EaB28258dbeddd39330eAFD3Bb1`](https://testnet.arcscan.app/address/0x8e9367F710684EaB28258dbeddd39330eAFD3Bb1) ✅ verified |
| Example payment | [tx on ArcScan](https://testnet.arcscan.app/tx/0x9622ad03c8fb50426e12a90bbcb1e6b7646f8f3ddb4d4ae4c65b6ae9f9c1bbd5) |

The router is intentionally minimal and trustless:

- `pay(address recipient, string memo)` — forwards the attached native USDC to the recipient **atomically** and emits a `PaymentSent` event. The contract **never holds funds**, has **no owner**, and **no special privileges**.
- `totalPayments` / `totalVolume` — public counters anyone can verify.
- Reverts on zero amount, zero address, self-payment, and failed transfers.

## ⚙️ Network

| | |
|---|---|
| Network | Arc Testnet |
| Chain ID | `5042002` |
| RPC | `https://rpc.testnet.arc.network` |
| Gas token | USDC (native) |
| Explorer | [testnet.arcscan.app](https://testnet.arcscan.app) |
| Faucet | [faucet.circle.com](https://faucet.circle.com) |

> On Arc, USDC is the **native gas token**: native value uses 18 decimals, while the optional ERC-20 interface at `0x3600...0000` uses 6 decimals. PayLinq routes payments as native value and reads balances via the ERC-20 interface, per Arc docs recommendations.

## 🚀 Try it

1. Install [MetaMask](https://metamask.io/download/)
2. Get free testnet USDC from the [Circle Faucet](https://faucet.circle.com) (select **Arc Testnet**)
3. Open the [live demo](https://paylinq-beta.vercel.app) → create a link → pay it from another account

## 🛠 Tech stack

Single-file static frontend (`index.html`) — vanilla JS + [ethers v6](https://docs.ethers.org/v6/), no build step. Solidity 0.8 router contract deployed via Remix. Hosted on Vercel.

## 🗺 Roadmap

- [x] Payment links + QR codes
- [x] Router contract with onchain payment records
- [x] "Already paid" detection from contract events
- [x] Live onchain stats
- [x] Merchant dashboard (all received payments, read from events)
- [ ] EURC support
- [ ] Mainnet deployment when Arc mainnet launches

## 📄 License

MIT
