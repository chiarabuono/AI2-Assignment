(define 
    (domain warehouse)
    (:requirements  :strips :typing :conditional-effects :equality :fluents :numeric-fluents
                    :time :duration-inequalities :negative-preconditions
        ; :durative-actions :timed-initial-literals :negative-preconditions :disjunctive-preconditions
    )
    (:types 
        crate 
        mover 
        loader
    )

    (:functions
        (weight ?w) ; weight of the crate
        (distance ?d) ; distance of the crate from loading bay
        (fragile ?f) ; 0 for not fragile, 1 for fragile
        (group ?g) ; 0 for no group, 1 for group A, 2 for group B
        (carried ?c) ; the crate is carried by no-one (0), by a mover (1), by two movers (2)
        (at-loading-bay ?c)
        (arm ?l)
    )

    (:predicates
        (hold ?c - crate ?m - mover)
        (loaded ?c - crate)
        (free ?m - mover)
        (free_loader ?l - loader)
        (reached ?m - mover ?c - crate) ; the mover reached the crate
        (without-target ?m - mover)     ; the mover has not a target
    )

    ; loader loads one crate per time
    (:durative-action load
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 4)
        :condition (and 
            (over all (= (arm ?l) 0))
            (at start (= (at-loading-bay ?c) 1))
            (at start (free_loader ?l))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 0))
        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (free_loader ?l))
            (at end (loaded ?c))
        )
    )

    (:durative-action load-arm
        :parameters (?c - crate ?l - loader ?a - loader)
        :duration (= ?duration 4)
        :condition (and 
            (at start (free_loader ?a))
            (at start (not (free_loader ?l)))
            (at start (not (= ?l ?a)))
            (over all (= (arm ?a) 1))
            (over all (= (arm ?l) 0))
            (at start (= (at-loading-bay ?c) 1))
            (at start (= (carried ?c) 0))
            (over all (< (weight ?c) 50))
        )
        :effect (and 
            (at start (not (free_loader ?a)))
            (at end (free_loader ?a))
            (at end (loaded ?c))
        )
    )

    (:durative-action load-fragile
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 6)
        :condition (and 
            (over all (= (arm ?l) 0))
            (at start (free_loader ?l))
            (at start (= (at-loading-bay ?c) 1))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1))
        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (free_loader ?l))
            (at end (loaded ?c))
        )
    )
    (:durative-action load-fragile-arm
        :parameters (?c - crate ?a - loader ?l - loader)
        :duration (= ?duration 6)
        :condition (and 
            (at start (not (free_loader ?l)))
            (at start (free_loader ?a))
            (at start (not (= ?l ?a)))
            (over all (= (arm ?a) 1))
            (over all (= (arm ?l) 0))
            (at start (= (at-loading-bay ?c) 1))
            (at start (= (carried ?c) 0))
            (over all (< (weight ?c) 50))
        )
        :effect (and 
            (at start (not (free_loader ?a)))
            (at end (free_loader ?a))
            (at end (loaded ?c))
        )
    )

    ; start - moving
    (:action pick-up
        :parameters (?c - crate ?m - mover)
        :precondition (and  
            (free ?m)
            (= (carried ?c) 0)
            (< (weight ?c) 50) 
            (reached ?m ?c) 
            (= (at-loading-bay ?c) 0)
            (= (fragile ?c) 0)
        )
        :effect (and    
            (hold ?c ?m) 
            (not (free ?m))
            (not(reached ?m ?c)) 
            (assign (carried ?c) 1)
        )
    )

    (:action pick-up-two-movers
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :precondition (and  
            (free ?m1) 
            (free ?m2) 
            (= (carried ?c) 0) 
            (= (at-loading-bay ?c) 0)
            (reached ?m1 ?c) 
            (reached ?m2 ?c)
        )
        :effect (and    
            (assign (carried ?c) 2)
            (not (free ?m1)) 
            (not (free ?m2))
            (hold ?c ?m1) 
            (hold ?c ?m2)
        )
    )

    ; a loader could be moving in the same direction target by another mover
    (:durative-action moving-empty
        :parameters (?m - mover ?c - crate) ; ?l - loader
        :duration (= ?duration (/ (distance ?c) 10))
        :condition (and 
            (at start  (free ?m))
            (at start (without-target ?m))
            (at start (= (at-loading-bay ?c) 0))
            (at start (not (reached ?m ?c)))
        )
        :effect (and
            (at start (not (free ?m)))
            (at start (not (without-target ?m)))
            (at end (reached ?m ?c))
            (at end (free ?m))
        )
    )
    
    (:durative-action moving
        :parameters (?c - crate ?m - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            (over all (hold ?c ?m))
            (at start (= (at-loading-bay ?c) 0))
            (at start (<= (weight ?c) 50))
            (at start (= (carried ?c) 1))
        )
        :effect (and
            (at end (assign (at-loading-bay ?c) 1))
            (at end (assign (distance ?c) 0))
            ;(decrease (distance ?c) (/ (* (distance ?c) (weight ?c)) 100))
        )
    )

    (:durative-action moving-two-movers-light
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 150))
        :condition (and
            (at start (<= (weight ?c) 50))
            (at start (= (carried ?c) 2))
            (over all (hold ?c ?m1))
            (over all (not(= ?m1 ?m2)))
            (over all (hold ?c ?m2))
            (at start (= (at-loading-bay ?c) 0))
        )
        :effect (and 
            (at end (assign (at-loading-bay ?c) 1))
            (at end (assign (distance ?c) 0))
        )
    )

    (:durative-action moving-two-movers-heavy
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            (at start (> (weight ?c) 50))
            (at start (= (at-loading-bay ?c) 0))
            (at start (= (carried ?c) 2))
            (over all (hold ?c ?m1))
            (over all (not(= ?m1 ?m2)))
            (over all (hold ?c ?m2))
        )
        :effect (and 
            (at end (assign (at-loading-bay ?c) 1))
            (at end (assign (distance ?c) 0))
        )
    )

    (:action drop
        :parameters (?c - crate ?m - mover ?l -loader ?a -loader)
        :precondition (and  
            (= (distance ?c) 0) 
            (hold ?c ?m)
            (= (carried ?c) 1)
            (free_loader ?l) 
            (free_loader ?a)
        )
        :effect (and  
            (free ?m)
            (not (hold ?c ?m))
            (assign (carried ?c) 0)
            (without-target ?m)      
        )
    )
    
    (:action drop-two-movers
        :parameters (?c - crate ?m1 - mover ?m2 - mover ?l -loader ?a - loader)
        :precondition (and 
            (= (distance ?c) 0) 
            (hold ?c ?m1) 
            (hold ?c ?m2) 
            (not(= ?m1 ?m2)) ;(not(free ?m1)) (not(free ?m2))
            (= (carried ?c) 2)
            (free_loader ?l) 
            (free_loader ?a)
        )
        :effect (and  
            (free ?m1) 
            (free ?m2)
            (not (hold ?c ?m1)) 
            (not (hold ?c ?m2))
            (assign (carried ?c) 0)
            (without-target ?m1) 
            (without-target ?m2)
        )
    )
)