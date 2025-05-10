(define 
    (domain warehouse)
    (:requirements  :strips :typing :conditional-effects :equality :fluents :numeric-fluents
                    :time :duration-inequalities 
        ; :durative-actions :timed-initial-literals :negative-preconditions :disjunctive-preconditions
    )
    (:types 
        crate 
        mover 
        loader
    )

    (:functions
        ; crate
        (weight ?w - crate) ; weight of the crate
        (distance ?d - crate) ; distance of the crate from loading bay
        (fragile ?f -crate) ; 0 for not fragile, 1 for fragile
        (group ?g - crate) ; 0 for no group, 1 for group A, 2 for group B
    )

    (:predicates
        (hold ?c - crate ?m - mover)
        (loaded ?c - crate)
        (free ?m - mover)
        (free_loader ?l - loader)  
        (reached ?m - mover ?c - crate) ; the mover reached the crate
        (without-target ?m - mover)     ; the mover has not a target
        (not-carried ?c - crate) ; true if not false if carried

    )

    (:durative-action load
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
        )
        :effect (and 
            (at start (and(not (free_loader ?l)) ))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )


    (:durative-action move
        :parameters (?m - mover ?c - crate ?l - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            ; pick up
            (at start (and (free ?m) (reached ?m ?c)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (< (weight ?c) 50)))
            ; move
            (over all (>= (distance ?c) 0))

            ; drop
            (at end (free_loader ?l))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m)) (without-target ?m)))
            (at start (hold ?c ?m))
            (at start (not (not-carried ?c)))

            ; drop
            (at end (and (free ?m) (without-target ?m)))
            (at end (and (assign (distance ?c) 0)))
            (at end (not (hold ?c ?m)))
            (at end (not-carried ?c))

        )
    )

    (:durative-action move2movers-light
        :parameters (?m1 - mover ?m2 - mover ?c - crate ?l - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 150))
        :condition (and 
            ; pick up
            (at start (and (free ?m1) (reached ?m1 ?c)))
            (at start (and (free ?m2) (reached ?m2 ?c)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (< (weight ?c) 50)))
            ; move
            (over all (>= (distance ?c) 0))

            ; drop
            (at end (free_loader ?l))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m1)) (without-target ?m1)))
            (at start (and (not (free ?m2)) (without-target ?m2)))
            (at start (hold ?c ?m1))
            (at start (not (not-carried ?c)))

            ; drop
            (at end (and (free ?m1) (without-target ?m1)))
            (at end (and (free ?m2) (without-target ?m2)))
            (at end (and (assign (distance ?c) 0)))
            (at end (not (hold ?c ?m1)))
            (at end (not (hold ?c ?m2)))
            (at end (not-carried ?c))

        )
    )

    (:durative-action move2movers-heavy
        :parameters (?m1 - mover ?m2 - mover ?c - crate ?l - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            ; pick up
            (at start (and (free ?m1) (reached ?m1 ?c)))
            (at start (and (free ?m2) (reached ?m2 ?c)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (>= (weight ?c) 50)))
            ; move
            (over all (>= (distance ?c) 0))

            ; drop
            (at end (free_loader ?l))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m1)) (without-target ?m1)))
            (at start (and (not (free ?m2)) (without-target ?m2)))
            (at start (hold ?c ?m1))
            (at start (not (not-carried ?c)))

            ; drop
            (at end (and (free ?m1) (without-target ?m1)))
            (at end (and (free ?m2) (without-target ?m2)))
            (at end (and (assign (distance ?c) 0)))
            (at end (not (hold ?c ?m1)))
            (at end (not (hold ?c ?m2)))
            (at end (not-carried ?c))

        )
    )
        
    (:durative-action moving-empty
        :parameters (?m - mover ?c - crate)
        :duration (= ?duration (/ (distance ?c) 10))
        :condition (and
            (at start (free ?m))
            (at start (without-target ?m))
            (at start (> (distance ?c) 0))
        )
        :effect (and
            (at start (not (free ?m)))
            (at start (not (without-target ?m)))
            (at end (reached ?m ?c))
            (at end (free ?m))
        )
    )

)


