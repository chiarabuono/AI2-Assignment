(define 
    (domain warehouse)
    (:requirements  :strips :typing :conditional-effects :equality :fluents :numeric-fluents
                    :time :duration-inequalities :negative-preconditions
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
        (arm ?a - loader)  ; loader cheap (arm = 1) or not (arm = 0)

        ; group and loader
        (groupMember ?m - groupClass) ; number of crate per group
        (groupId ?g - groupClass)
        (active-group)

        ; mover
        (battery ?m - mover) ; mover's battery level 
        (distMover ?m - mover) ; distance of the mover from loading bay
    )

    (:predicates
        (hold ?c - crate ?m - mover) ; true if crate c is held by mover m
        (loaded ?c - crate) ; true if crate c is loaded
        (free ?m - mover) ; true when the mover is not carrying any crate
        (free_loader ?l - loader)   ; true when loader is not loading any crate

        (reached ?m - mover ?c - crate) ; true if the mover reached the crate
        (without-target ?m - mover)     ; true when the mover has not a target
        (not-recharging ?m - mover) ; if false the mover can move
        

    )

    ; Group extension. Select a group
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

    ; Group extension. Reset active group to 0
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

    ; basic load function
    (:durative-action load-group
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (arm ?l) 0))    ; loader not arm
            (at start (= (fragile ?c) 0)) ; not fragile

            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))

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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 0)) ; not fragile

            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))

            ; arm
            (at start (= (arm ?l) 1))
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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (arm ?l) 0))    ; loader not arm
            (at start (= (fragile ?c) 1)) ; fragile

            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))

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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1)) ; fragile

            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))

            ; arm
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (arm ?l) 0)) ; not arm
            (at start (= (fragile ?c) 0)) ; not fragile
            
            ; no group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 0)) ; not fragile

            ; arm
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

            ; no group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1)) ; fragile
            (at start (= (arm ?l) 0))  ; not arm

            ; no group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
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
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (= (carried ?c) 0))
            (at start (= (fragile ?c) 1)) ; fragile

            ; arm
            (at start (= (arm ?l) 1)) 
            (at start (< (weight ?c) 50))

            ; no group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
        )
        :effect (and 
            (at start (and(not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    ; one mover picks up a crate
    (:action pick-up
        :parameters (?c - crate ?m - mover)
        :precondition (and  
            (free ?m)
            (= (carried ?c) 0)
            (< (weight ?c) 50) 
            (reached ?m ?c) 
            (= (fragile ?c) 0)
            (> (distance ?c) 0)         ; to avoid picking up a crate that is already at the loading bay
        )
        :effect (and    
            (hold ?c ?m) 
            (not (free ?m))
            (not(reached ?m ?c)) 
            (assign (carried ?c) 1)
        )
    )

    ; two movers pick up a crate
    (:action pick-up-two-movers
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :precondition (and  
            (free ?m1) 
            (free ?m2) 
            (= (carried ?c) 0) 
            (reached ?m1 ?c) 
            (reached ?m2 ?c)
            (> (distance ?c) 0) ; to avoid picking up a crate that is already at the loading bay
        )
        :effect (and    
            (assign (carried ?c) 2)
            (not (free ?m1)) 
            (not (free ?m2))
            (hold ?c ?m1) 
            (hold ?c ?m2)
        )
    )

    ; battery extension
    (:action recharge
        :parameters (?m - mover)
        :precondition (and 
            (= (distMover ?m) 0)
            (free ?m)
        )
        :effect (and (assign (battery ?m) 20))
    )

    ; Recharge durative action    

    ; (:durative-action recharge
    ;     :parameters (?m - mover)
    ;     :duration (= ?duration 1)
    ;     :condition (and 
    ;         (over all (and (= (distMover ?m) 0)))
    ;     )
    ;     :effect (and 
    ;         (at start (not (not-recharging ?m)))
    ;         (at end (not-recharging ?m))
    ;         (at end (assign (battery ?m) 20))
    ;     )
    ; )



    ; moving towards the crate
    (:durative-action moving-empty
        :parameters (?m - mover ?c - crate)
        :duration (= ?duration (/ (distance ?c) 10))
        :condition (and
            (at start (free ?m))
            (at start (without-target ?m))
            (over all (not-recharging ?m))
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

    ; moving crate back to the loading bay with one mover
    (:durative-action moving
        :parameters (?c - crate ?m - mover)
        :duration (>= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            (over all (hold ?c ?m))
            (at start (= (carried ?c) 1))
            (at start (> (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))
        )
        :effect (and
            (at end (assign (distance ?c) 0))
            (at end (decrease (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))
        )
    )

    ; moving light crate back to the loading bay with two movers
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

    ; moving heavy crate back to the loading bay with two movers
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

    ; one mover drops a crate
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
    
    ; two movers drop a crate
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