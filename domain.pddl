(define (domain warehouse)

(:requirements :strips :negative-preconditions :fluents :typing :conditional-effects :equality :numeric-fluents :time :duration-inequalities)
; :durative-actions :timed-initial-literals :negative-preconditions 
(:types crate mover loader )

(:functions
  (weight ?w - crate) ; weight of the crate
  (distance ?d - crate) ; distance of the crate from loading bay
  (fragile ?f -crate) ; 0 for not fragile, 1 for fragile
  (group ?g - crate) ; 0 for no group, 1 for group A, 2 for group B
)


; un-comment following line if constants are needed
;(:constants )

(:predicates
  (hold ?c - crate ?m - mover)
  (loaded ?c - crate)
  (free ?m - mover)
  (free_loader ?l - loader)
  (at ?c - crate ?l - loader)
  (on-floor ?c - crate) ; negation of hold (more or less)
  ;(at-mover ?m -mover ?l - loader)    ; indicates if the mover is at loader
  (reached ?m - mover ?c - crate) ; the mover reached the crate
)

; loader loads one crate per time
(:durative-action load
    :parameters (?c - crate ?l - loader)
    :duration (= ?duration 4)
    :condition (and 
        (at start (and (at ?c ?l) (free_loader ?l)))
        (at start (on-floor ?c))
    )
    :effect (and 
        (at start (and(not (free_loader ?l)) (not (on-floor ?c))))
        (at end (and (free_loader ?l) (loaded ?c)))
    )
)



; start - moving
(:action pick-up
  :parameters (?c - crate ?m - mover)
  :precondition (and 
    (free ?m)
    (on-floor ?c)
    ;(< (weight ?c) 50) 
    (reached ?m ?c)  ;(= (distance ?c) (distance-ml ?m))
  )
  :effect (and (hold ?c ?m)
    (not (free ?m))
    (not(reached ?m ?c))
    (not (on-floor ?c)) 
    ;(moving ?c ?m)
  )
)




(:durative-action moving-empty
  :parameters (?m - mover ?c - crate) ; ?l - loader
  :duration (= ?duration (/ (distance ?c) 10))
  :condition (and 
    (at start  (free ?m))
    ;(at start (at-mover ?m ?l))
    (at start (> (distance ?c) 0))
   )
  :effect (and
    (at start (not (free ?m)))
    ;(at end (not(at-mover ?m ?l)))
    ;(at end (assign (distance-ml ?m) (distance ?c))) 
    (at end (reached ?m ?c))
    (at end (free ?m))

  )
)

   


; TO DO - implementing moving such that only the mover that picked up the crate is moving it
; create a macro = pick-up + moving?
  (:durative-action moving
    :parameters (?c - crate ?m - mover ?l - loader)
    :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
    :condition (and 
      (at start (hold ?c ?m))
      (at start (> (distance ?c) 0))
      (at start (> (weight ?c) 0))
    )
    :effect (and
        (at end (at ?c ?l))
        (at end (assign (distance ?c) 0))
        ;(decrease (distance ?c) (/ (* (distance ?c) (weight ?c)) 100))
    )
  )

(:action drop
  :parameters (?c - crate ?m - mover)
  :precondition (and (= (distance ?c) 0)
  )
  :effect (and 
    (free ?m)
    (not (hold ?c ?m))
    (on-floor ?c)
  )
)

)


