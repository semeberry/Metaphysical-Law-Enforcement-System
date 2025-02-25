;; Karmic Balance Contract

(define-map karmic-accounts
  { entity-id: uint }
  {
    balance: int,
    last-adjustment: uint
  }
)

(define-data-var next-entity-id uint u0)

(define-public (create-karmic-account)
  (let
    ((new-id (+ (var-get next-entity-id) u1)))
    (var-set next-entity-id new-id)
    (ok (map-set karmic-accounts
      { entity-id: new-id }
      {
        balance: 0,
        last-adjustment: block-height
      }
    ))
  )
)

(define-public (adjust-karma (entity-id uint) (action-value int))
  (let
    ((account (unwrap! (map-get? karmic-accounts { entity-id: entity-id }) (err u404))))
    (ok (map-set karmic-accounts
      { entity-id: entity-id }
      {
        balance: (+ (get balance account) action-value),
        last-adjustment: block-height
      }
    ))
  )
)

(define-read-only (get-karmic-balance (entity-id uint))
  (get balance (default-to { balance: 0, last-adjustment: u0 } (map-get? karmic-accounts { entity-id: entity-id })))
)

