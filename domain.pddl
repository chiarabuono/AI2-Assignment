(define (domain warehouse)

(:requirements  :strips :fluents :typing :conditional-effects :equality :numeric-fluents 
                :time :duration-inequalities 
                :negative-preconditions :disjunctive-preconditions
    
)
; :durative-actions :timed-initial-literals
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
    (on-floor ?c - crate)      
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
    :precondition (and  (free ?m)
                        (on-floor ?c)
                        (< (weight ?c) 50) (> (distance ?c) 0)
    )
    :effect (and (hold ?c ?m)
    (not (free ?m))
    (not (on-floor ?c)) 
    )
)

(:action pick-up-two-movers
    :parameters (?c - crate ?m1 - mover ?m2 - mover)
    :precondition (and  (free ?m1) (free ?m2) 
                        (on-floor ?c) (> (distance ?c) 0))
    
    :effect (and    (not (on-floor ?c))
                    (not (free ?m1)) (not (free ?m2))
                    (hold ?c ?m1) (hold ?c ?m2)
    )
)


  (:durative-action moving  ; one mover
    :parameters (?c - crate ?m - mover ?l - loader)
    :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
    :condition (and 
      (over all (hold ?c ?m))
      (over all (>= (distance ?c) 0))
      (at start (<= (weight ?c) 50))
    )
    :effect (and
        (at end (at ?c ?l))
        (at end (assign (distance ?c) 0))
        ;(decrease (distance ?c) (/ (* (distance ?c) (weight ?c)) 100))
    )
  )

(:durative-action moving-two-movers-light
    :parameters (?c - crate ?m1 - mover ?m2 - mover ?l - loader)
    :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 150))
    :condition (and
        (at start (<= (weight ?c) 50))
        (over all (and (not(= ?m1 ?m2)) (hold ?c ?m1) (hold ?c ?m2)))
        (over all (> (distance ?c) 0))
    )
    :effect (and 
        (at end (at ?c ?l))
        (at end (assign (distance ?c) 0))
    )
)

(:durative-action moving-two-movers-heavy
    :parameters (?c - crate ?m1 - mover ?m2 - mover ?l - loader)
    :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
    :condition (and 
        (at start (> (weight ?c) 50))
        (over all (> (distance ?c) 0))
        (over all (and (not(= ?m1 ?m2)) (hold ?c ?m1) (hold ?c ?m2)))
    )
    :effect (and 
        (at end (at ?c ?l))
        (at end (assign (distance ?c) 0))
    )
)

;   (:action drop-all
;     :parameters (?c - crate)
;     :precondition (and (= (distance ?c) 0) (exists (?m - mover) (hold ?c ?m)))
;     :effect (and
;       (on-floor ?c)
;       (forall (?m - mover) (when (hold ?c ?m) (and (free ?m) (not (hold ?c ?m)) )))
;     )
;   )


  (:action drop
      :parameters (?c - crate ?m1 - mover ?m2 - mover)
      :precondition (and (= (distance ?c) 0) (hold ?c ?m1) (not (hold ?c ?m2))
      )
      :effect (and (free ?m1)
                    (not (hold ?c ?m1))
                    
      )
  )
  
    (:action drop-two-movers
      :parameters (?c - crate ?m1 - mover ?m2 - mover)
      :precondition (and (= (distance ?c) 0) (hold ?c ?m1) (hold ?c ?m2) 
                            (not(= ?m1 ?m2)) ;(not(free ?m1)) (not(free ?m2))
      )
      :effect (and  (free ?m1) (free ?m2)
                    (not (hold ?c ?m1)) (not (hold ?c ?m2))
                    (on-floor ?c)
      )
  )

)


