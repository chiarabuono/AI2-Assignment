(define (domain warehouse)

(:requirements :strips :fluents :typing :conditional-effects :equality :numeric-fluents :time :duration-inequalities :numeric-fluents)
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
    (hold ?c - crate)
    (loaded ?c - crate)
    (free ?m - mover)
    (free_loader ?l - loader)
    (at ?c - crate ?l - loader)
    (on-floor ?c - crate)       ; negation of hold (more or less)
)


  (:action load
    :parameters (?c - crate ?l - loader)
    :precondition (and (at ?c ?l) (on-floor ?c)
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
        (> (distance ?c) 0)
    )
    :effect (and (hold ?c)
    (not (free ?m)) 
    ;(moving ?c ?m)
    )
)


  (:durative-action moving
    :parameters (?c - crate ?m - mover ?l - loader)
    :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
    :condition (and 
      (at start (hold ?c))
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
      :effect (and (free ?m)
                    (not (hold ?c))
                    (on-floor ?c)
      )
  )
  

)

; ? I am using a durative action, is it all right if I use BFWS or OPTIC as planning engines?
; Is it correct using functions for 'attributes'?
; :negative-preconditions can we use it?