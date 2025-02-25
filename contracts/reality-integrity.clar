;; Reality Integrity Contract

(define-map reality-breaches
  { breach-id: uint }
  {
    location: (tuple (x int) (y int) (z int)),
    severity: uint,
    status: (string-ascii 20)
  }
)

(define-data-var next-breach-id uint u0)

(define-public (register-breach (x int) (y int) (z int) (severity uint))
  (let
    ((new-id (+ (var-get next-breach-id) u1)))
    (var-set next-breach-id new-id)
    (ok (map-set reality-breaches
      { breach-id: new-id }
      {
        location: { x: x, y: y, z: z },
        severity: severity,
        status: "unrepaired"
      }
    ))
  )
)

(define-public (repair-breach (breach-id uint))
  (let
    ((breach (unwrap! (map-get? reality-breaches { breach-id: breach-id }) (err u404))))
    (ok (map-set reality-breaches
      { breach-id: breach-id }
      (merge breach { status: "repaired" })
    ))
  )
)

(define-read-only (get-breach (breach-id uint))
  (map-get? reality-breaches { breach-id: breach-id })
)

