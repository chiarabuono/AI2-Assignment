(define (domain warehouse)

(:requirements :strips :negative-preconditions :fluents :typing :conditional-effects :equality :numeric-fluents :time :duration-inequalities)
; :durative-actions :timed-initial-literals :negative-preconditions 
(:types crate mover loader )

(:functions
  (weight ?c - crate) ;- number ; weight of the crate
  (distance ?d - crate) ;- number ; distance of the crate from loading bay
  (distance-ml ?m - mover) ; distance of the mover form the loader
)


; un-comment following line if constants are needed
;(:constants )

(:predicates
  (hold ?c - crate ?m - mover)
  (loaded ?c - crate)
  (free ?m - mover)
  (at ?c - crate ?l - loader)
  (on-floor ?c - crate) ; negation of hold (more or less)
  ;(at-mover ?m -mover ?l - loader)    ; indicates if the mover is at loader
  (reached ?m - mover ?c - crate) ; the mover reached the crate
)


(:action load
  :parameters (?c - crate ?l - loader)
  :precondition (and 
    (at ?c ?l) 
    (on-floor ?c)
  )
  :effect (and 
    (loaded ?c)
  )
)


; start - moving
(:action pick-up
  :parameters (?c - crate ?m - mover)
  :precondition (and 
    (free ?m)
    ;(< (weight ?c) 50) 
    (reached ?m ?c)  ;(= (distance ?c) (distance-ml ?m))
  )
  :effect (and (hold ?c ?m)
  (not (free ?m))
  (not(reached ?m ?c))
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
    )
  )
    ;(decrease (distance ?c) (/ (* (distance ?c) (weight ?c)) 100))

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

; ? I am using a durative action, is it all right if I use BFWS or OPTIC as planning engines?
; Is it correct using functions for 'attributes'?
; :negative-preconditions can we use it?