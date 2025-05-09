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
        groupClass
    )

    (:functions
        ; crate
        (weight ?w - crate) ; weight of the crate
        (distance ?d - crate) ; distance of the crate from loading bay
        (fragile ?f -crate) ; 0 for not fragile, 1 for fragile
        (group ?g - crate) ; 0 for no group, 1 for group A, 2 for group B
        (carried ?c - crate) ; the crate is carried by no-one (0), by a mover (1), by two movers (2)
        (arm ?a - loader)

        ; group and loader
        (groupMember ?m - groupClass) ; number of crate per group
        (groupId ?g - groupClass)
        (active-group)

        ; mover
        (battery ?m - mover) 
        (distMover ?m - mover) ; distance of the mover from the loading bay
    )

    (:predicates
        (hold ?c - crate ?m - mover)
        (loaded ?c - crate) 
        (free ?m - mover)
        (free_loader ?l - loader)   

        (reached ?m - mover ?c - crate) ; the mover reached the crate
        (without-target ?m - mover)     ; the mover has not a target

    )

    (:action choose_group
        :parameters (?g - groupClass)
        :precondition (and 
            (> (groupMember ?g) 0)
            (= (active-group) 0)
        )
        :effect (and 
            (assign (active-group) (groupId ?g))
        )
    )

    (:action reset_group
        :parameters (?g - groupClass)
        :precondition (and 
            (= (groupMember ?g) 0)
            (= (active-group) (groupId ?g))
        )
        :effect (and 
            (assign (active-group) 0)
        )
    )

    (:durative-action load-group
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (= (arm ?l) 0))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))
            (at start (= (fragile ?c) 0))

        )
        :effect (and 
            (at start (and(not (free_loader ?l)) ))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )

    (:durative-action load-group-arm
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (= (arm ?l) 1))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))
            (at start (= (fragile ?c) 0))
            (at start (< (weight ?c) 50))
        )
        :effect (and 
            (at start (and(not (free_loader ?l)) ))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )

        (:durative-action load-group-fragile
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 6)
        :condition (and 
            (at start (= (arm ?l) 0))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))
            (at start (= (fragile ?c) 1))
        )
        :effect (and 
            (at start (and(not (free_loader ?l)) ))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )

    (:durative-action load-group-arm-fragile
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 6)
        :condition (and 
            (at start (= (arm ?l) 1))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))
            (at start (< (weight ?c) 50))
            (at start (= (fragile ?c) 1))
        )
        :effect (and 
            (at start (and(not (free_loader ?l)) ))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )

    (:durative-action load
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (= (arm ?l) 0))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))

            (at start (= (fragile ?c) 0))
        )
        :effect (and 
            (at start (and (not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:durative-action load-arm
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 4)
        :condition (and 
            (at start (= (arm ?l) 1))
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 0))
            (at start (< (weight ?c) 50))
        )
        :effect (and 
            (at start (and (not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:durative-action load-fragile
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 6)
        :condition (and 
            (at start (= (arm ?l) 0)) 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1))
        )
        :effect (and 
            (at start (and(not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

     (:durative-action load-arm-fragile
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 6)
        :condition (and 
            (at start (= (arm ?l) 1)) 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1))
            (at start (< (weight ?c) 50))
        )
        :effect (and 
            (at start (and(not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:action pick-up
        :parameters (?c - crate ?m - mover)
        :precondition (and  
            (free ?m)
            (= (carried ?c) 0)
            (< (weight ?c) 50) 
            (reached ?m ?c) 
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

    (:durative-action recharge
        :parameters (?m - mover)
        :duration (= ?duration 1)
        :condition (and 
            (at start (and (= (distMover ?m) 0)))
        )
        :effect (and 
            (at end (and (assign (battery ?m) 20)
            ;(at end (and (increase (battery ?m) 5)
            ))
        )
    )

    
(:durative-action moving-empty
    :parameters (?m - mover ?c - crate)
    :duration (= ?duration (/ (distance ?c) 10))
    :condition (and
        (at start (free ?m))
        (at start (without-target ?m))
        (at start (> (distance ?c) 0))
        (at start (>= (battery ?m) (/ (distance ?c) 10)))
    )
    :effect (and
        (at start (not (free ?m)))
        (at start (not (without-target ?m)))
        (at end (reached ?m ?c))
        (at end (free ?m))
        (at end (decrease (battery ?m) (/ (distance ?c) 10)))
        (at end (assign (distMover ?m) (distance ?c)))
    )
)

    (:durative-action moving
        :parameters (?c - crate ?m - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            (over all (hold ?c ?m))
            (at start (<= (weight ?c) 50))
            (at start (= (carried ?c) 1))
            (at start (> (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))
        )
        :effect (and
            (at end (assign (distance ?c) 0))
            (at end (decrease (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))
        )
    )

    (:durative-action moving-two-movers-light
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 150))
        :condition (and
            (at start (<= (weight ?c) 50))
            (at start (= (carried ?c) 2))
            (over all (and (not(= ?m1 ?m2)) (hold ?c ?m1) (hold ?c ?m2)))
            (over all (> (distance ?c) 0))
            (at start (> (battery ?m1) (/ (* (distance ?c) (weight ?c)) 100)))
            (at start (> (battery ?m2) (/ (* (distance ?c) (weight ?c)) 100)))
        )
        :effect (and 
            (at end (assign (distance ?c) 0))
            (at end (decrease (battery ?m1) (/ (* (distance ?c) (weight ?c)) 150)))
            (at end (decrease (battery ?m2) (/ (* (distance ?c) (weight ?c)) 150)))
        )
    )

    (:durative-action moving-two-movers-heavy
        :parameters (?c - crate ?m1 - mover ?m2 - mover ?l - loader)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            (at start (> (weight ?c) 50))
            (at start (= (carried ?c) 2))
            (over all (and (not(= ?m1 ?m2)) (hold ?c ?m1) (hold ?c ?m2)))
            (at start (> (battery ?m1) (/ (* (distance ?c) (weight ?c)) 100)))
            (at start (> (battery ?m2) (/ (* (distance ?c) (weight ?c)) 100)))
        )
        :effect (and 
            (at end (assign (distance ?c) 0))
            (at end (decrease (battery ?m1) (/ (* (distance ?c) (weight ?c)) 100)))
            (at end (decrease (battery ?m2) (/ (* (distance ?c) (weight ?c)) 100)))
        )
    )

    (:action drop
        :parameters (?c - crate ?m - mover ?l1 - loader ?l2 - loader)
        :precondition (and  
            (= (distance ?c) 0) 
            (hold ?c ?m)
            (= (carried ?c) 1)
            (free_loader ?l1)
            (free_loader ?l2)
            (not(= ?l1 ?l2))
        )
        :effect (and  
            (free ?m)
            (not (hold ?c ?m))
            (assign (carried ?c) 0)
            (without-target ?m)
            (assign (distMover ?m) 0)     
        )
    )
    
    (:action drop-two-movers
        :parameters (?c - crate ?m1 - mover ?m2 - mover ?l1 - loader ?l2 - loader)
        :precondition (and 
            (= (distance ?c) 0) 
            (hold ?c ?m1) 
            (hold ?c ?m2) 
            (not(= ?m1 ?m2))
            (= (carried ?c) 2)
            (free_loader ?l1)
            (free_loader ?l2)
            (not(= ?l1 ?l2))
        )
        :effect (and  
            (free ?m1) 
            (free ?m2)
            (not (hold ?c ?m1)) 
            (not (hold ?c ?m2))
            (assign (carried ?c) 0)
            (without-target ?m1) 
            (without-target ?m2)
            (assign (distMover ?m1) 0)
            (assign (distMover ?m2) 0)
        )
    )
)