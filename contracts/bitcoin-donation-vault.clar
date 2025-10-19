;; ----------------------------------------------------------------------------------
;; Contract: bitcoin-donation-vault.clar
;; Author: Clarity Camp / You
;; Description: A donation vault to support Bitcoin-related development.
;;              Users can donate STX, and the contract tracks donations
;;              per user. Only the contract owner can withdraw the funds.
;; ----------------------------------------------------------------------------------

;; --- Error Codes ---
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NO-DONATIONS (err u101))

;; --- State Variables ---
(define-data-var contract-owner principal tx-sender)
(define-data-var total-donations uint u0)

;; --- Mapping: donor address -> total amount donated ---
(define-map donations principal uint)

;; ---------------------------------------------------------
;; --- Public Functions
;; ---------------------------------------------------------

;; @desc Allows anyone to donate STX to support Bitcoin causes.
(define-public (donate (amount uint))
(let ((transfer-result (stx-transfer? amount tx-sender (as-contract tx-sender))))
  (match transfer-result
    success (let (
          (previous (default-to u0 (map-get? donations tx-sender)))
          (new-amount (+ previous amount))
        )
      (map-set donations tx-sender new-amount)
      (var-set total-donations (+ (var-get total-donations) amount))
      (print { action: "donate", donor: tx-sender, amount: amount })
      (ok true)
    )
    error (err error)
  )
))

;; @desc Allows the contract owner to withdraw all funds from the vault.
(define-public (withdraw (recipient principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (let ((balance (stx-get-balance (as-contract tx-sender))))
      (asserts! (> balance u0) ERR-NO-DONATIONS)
      (try! (stx-transfer? balance (as-contract tx-sender) recipient))
      (print { action: "withdraw", to: recipient, amount: balance })
      (ok true)
    )
  )
)

;; ---------------------------------------------------------
;; --- Read-Only Functions
;; ---------------------------------------------------------

;; @desc Get the total amount of STX donated to this vault.
(define-read-only (get-total-donations)
  (ok (var-get total-donations))
)

;; @desc Get the total amount donated by a specific user.
(define-read-only (get-user-donation (user principal))
  (ok (default-to u0 (map-get? donations user)))
)

;; @desc Get the current balance of the contract vault.
(define-read-only (get-vault-balance)
  (ok (stx-get-balance (as-contract tx-sender)))
)

;; @desc Get the contract owner.
(define-read-only (get-owner)
  (ok (var-get contract-owner))
)
