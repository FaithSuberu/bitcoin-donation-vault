A secure donation vault built in Clarity to support Bitcoin-related development through STX contributions.

---

## 📜 Overview

This smart contract allows users to **donate STX tokens** to a vault, which is **managed by the contract owner**. Each donation is **tracked per user**, and only the owner can withdraw the accumulated funds.

- 🧑‍💻 Users can contribute STX.
- 📊 Donations are tracked per address.
- 🔐 Only the contract owner can withdraw funds.
- 🧾 Read-only views for transparency.

---

## ✨ Features

| Function         | Type        | Description |
|------------------|-------------|-------------|
| `donate`         | Public      | Donate STX to the vault; tracked by user address. |
| `withdraw`       | Public      | Owner-only function to withdraw all vault funds. |
| `get-total-donations` | Read-only | Returns the total STX donated to the vault. |
| `get-user-donation`   | Read-only | Returns how much a specific user has donated. |
| `get-vault-balance`   | Read-only | Returns the current STX balance of the contract. |
| `get-owner`           | Read-only | Returns the contract owner's address. |

---

## 🔐 Access Control

- Only the address that deployed the contract (owner) can withdraw funds.
- Donations can be made by **any STX address**.

---

## ⚠️ Error Codes

| Code | Description |
|------|-------------|
| `ERR-NOT-AUTHORIZED (err u100)` | Thrown if a non-owner attempts to withdraw funds. |
| `ERR-NO-DONATIONS (err u101)`   | Thrown if withdrawal is attempted with 0 STX in the vault. |

---

## 💰 How It Works

1. **User donates** STX via the `donate` function.
2. The contract:
   - Transfers STX into its own vault.
   - Updates the total donation amount.
   - Tracks donation per user.
3. The **contract owner** can withdraw all funds to a specified recipient address using `withdraw`.

---

## 📂 Contract Details

- **Language**: Clarity (for the Stacks blockchain)
- **File**: `bitcoin-donation-vault.clar`
- **Owner**: Set at deployment (`tx-sender`)

---

## 🧪 Example Usage

```clarity
;; Donate 100 STX
(donate u100)

;; Check total donations
(get-total-donations)

;; Get a user's donation history
(get-user-donation 'SP...')

;; Withdraw funds (owner only)
(withdraw 'SPRecipientAddress...')
✅ Deployment Considerations
Ensure contract-owner is correctly set at deployment.

Only deploy on trusted environments (e.g., mainnet or testnet with auditing).

Monitor stx-get-balance and donation logs for activity.

🛡 License
MIT License. Use at your own risk. Donations are non-refundable.

🤝 Contributing
Feel free to fork, suggest improvements, or open issues to improve this donation vault contract.
