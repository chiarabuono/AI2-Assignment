(define 
    (domain warehouse)
    (:requirements  :strips :typing :conditional-effects :equality :fluents :numeric-fluents
                    :time :duration-inequalities 
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

        ; group and loader
        (groupMember ?m - groupClass) ; number of crate per group
        (groupId ?g - groupClass) ; identification code for the group (ex. 1 for group A)
        (active-group)  ; currently loaded group
        (arm ?a - loader) ; loader cheap (arm = 1) or not (arm = 0)

        ; mover
        (battery ?m - mover) ; mover's battery level
        (distMover ?m - mover) ; distance of the mover from loading bay
    )

    (:predicates
        (hold ?c - crate ?m - mover) ; true if crate c is held by mover m
        (loaded ?c - crate) ; true if crate c is loaded
        (free ?m - mover) ; true when the mover is not carrying any crate
        (free_loader ?l - loader)  ; true when loader is not loading any crate
        (reached ?m - mover ?c - crate) ; true if the mover reached the crate
        (without-target ?m - mover)     ; true when the mover has not a target
        (not-carried ?c - crate) ; true when crate on the ground
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
    (:durative-action load
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (arm ?l) 0))       ; loader not arm
            (at start (= (fragile ?c) 0))   ; not fragile 

            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:durative-action load-group
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (arm ?l) 0))       ; loader not arm
            (at start (= (fragile ?c) 0))   ; not fragile 
            
            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))

        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )

    (:durative-action load-arm
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (fragile ?c) 0)) ; not fragile
            
            ; arm
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

            ; group
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
            (at start (not-carried ?c))
            (at start (= (arm ?l) 0)) ; loader not arm
            (at start (= (fragile ?c) 1)) ; fragile

            ; no group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
        )
        :effect (and 
            (at start (and(not (free_loader ?l))))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:durative-action load-group-arm
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (fragile ?c) 0)) ; not fragile

            ; arm 
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

            ; group
            (at start (= (group ?c) active-group))
            (at start (= (groupId ?g) active-group))
            (at start (> (group ?c) 0))
        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (and (free_loader ?l) (loaded ?c)))
            (at end (decrease (groupMember ?g) 1))
        )
    )
        
    (:durative-action load-group-fragile
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 6)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (arm ?l) 0)) ; loader not arm
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

    (:durative-action load-arm-fragile
        :parameters (?c - crate ?l - loader)
        :duration (= ?duration 6)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (fragile ?c) 1)) ; fragile

            ; arm
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

            ; group
            (at start (= (group ?c) 0))
            (at start (= (group ?c) active-group))
        )
        :effect (and 
            (at start (not (free_loader ?l)))
            (at end (and (free_loader ?l) (loaded ?c)))
        )
    )

    (:durative-action load-group-arm-fragile
        :parameters (?c - crate ?l - loader ?g - groupClass)
        :duration (= ?duration 6)
        :condition (and 
            (at start (and (= (distance ?c) 0) (free_loader ?l)))
            (at start (not-carried ?c))
            (at start (= (fragile ?c) 1)) ; fragile

            ; arm
            (at start (= (arm ?l) 1))
            (at start (< (weight ?c) 50))

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

    ; pick-up, moving, drop macro
    (:durative-action move
        :parameters (?m - mover ?c - crate ?l1 - loader ?l2 - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            ; pick up
            (at start (and (free ?m) (reached ?m ?c)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (< (weight ?c) 50)))
            (at start (> (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))
            (at start (= (fragile ?c) 0))

            ; move
            (over all (>= (distance ?c) 0))

            ; drop
            (at end (and (free_loader ?l1) (free_loader ?l2) (not (= ?l1 ?l2))))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m)) (without-target ?m)))
            (at start (hold ?c ?m))
            (at start (not (not-carried ?c)))

            ; move
            (at end (decrease (battery ?m) (/ (* (distance ?c) (weight ?c)) 100)))

            ; drop
            (at end (and (free ?m) (without-target ?m)))
            (at end (and (assign (distance ?c) 0) (assign (distMover ?m) 0)))
            (at end (not (hold ?c ?m)))
            (at end (not-carried ?c))

        )
    )

    ; pick-up-two-movers, moving-two-movers-light, drop-two-movers macro
    (:durative-action move2movers-light
        :parameters (?m1 - mover ?m2 - mover ?c - crate ?l1 - loader ?l2 - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 150))
        :condition (and 
            ; pick up
            (at start (and (free ?m1) (reached ?m1 ?c)))
            (at start (and (free ?m2) (reached ?m2 ?c)))
            (at start (not(= ?m1 ?m2)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (< (weight ?c) 50)))
            (at start (> (battery ?m1) (/ (* (distance ?c) (weight ?c)) 150)))
            (at start (> (battery ?m2) (/ (* (distance ?c) (weight ?c)) 150)))

            ; move
            (over all (>= (distance ?c) 0))

            ; drop
            (at end (and (free_loader ?l1) (free_loader ?l2) (not (= ?l1 ?l2))))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m1)) (without-target ?m1)))
            (at start (and (not (free ?m2)) (without-target ?m2)))
            (at start (hold ?c ?m1))
            (at start (not (not-carried ?c)))

            ; move
            (at end (decrease (battery ?m1) (/ (* (distance ?c) (weight ?c)) 150)))
            (at end (decrease (battery ?m2) (/ (* (distance ?c) (weight ?c)) 150)))

            ; drop
            (at end (and (free ?m1) (without-target ?m1)))
            (at end (and (free ?m2) (without-target ?m2)))
            (at end (and (assign (distance ?c) 0) (assign (distMover ?m1) 0) (assign (distMover ?m2) 0)))
            (at end (not (hold ?c ?m1)))
            (at end (not (hold ?c ?m2)))
            (at end (not-carried ?c))

        )
    )

    ; pick-up-two-movers, moving-two-movers-heavy, drop-two-movers macro
    (:durative-action move2movers-heavy
        :parameters (?m1 - mover ?m2 - mover ?c - crate ?l1 - loader ?l2 - loader)
        :duration (= ?duration (/ (* (distance ?c) (weight ?c)) 100))
        :condition (and 
            ; pick up
            (at start (and (free ?m1) (reached ?m1 ?c)))
            (at start (and (free ?m2) (reached ?m2 ?c)))
            (at start (not(= ?m1 ?m2)))
            (at start (and (not-carried ?c) (> (distance ?c) 0) (>= (weight ?c) 50)))
            (at start (> (battery ?m1) (/ (* (distance ?c) (weight ?c)) 100)))
            (at start (> (battery ?m2) (/ (* (distance ?c) (weight ?c)) 100)))

            ; move
            (over all (>= (distance ?c) 0))
            (over all (> (battery ?m1) 0))
            (over all (> (battery ?m2) 0))

            ; drop
            (at end (and (free_loader ?l1) (free_loader ?l2) (not (= ?l1 ?l2))))
        )
        :effect (and 
            ; pick up
            (at start (and (not (free ?m1)) (without-target ?m1)))
            (at start (and (not (free ?m2)) (without-target ?m2)))
            (at start (hold ?c ?m1))
            (at start (not (not-carried ?c)))

            ; move
            (at start (decrease (battery ?m1) (/ (* (distance ?c) (weight ?c)) 100)))
            (at start (decrease (battery ?m2) (/ (* (distance ?c) (weight ?c)) 100)))

            ; drop
            (at end (and (free ?m1) (without-target ?m1)))
            (at end (and (free ?m2) (without-target ?m2)))
            (at end (and (assign (distance ?c) 0) (assign (distMover ?m1) 0) (assign (distMover ?m2) 0)))
            (at end (not (hold ?c ?m1)))
            (at end (not (hold ?c ?m2)))
            (at end (not-carried ?c))

        )
    )
        
    ; moving towards the crate
    (:durative-action moving-empty
        :parameters (?m - mover ?c - crate)
        :duration (= ?duration (/ (distance ?c) 10))
        :condition (and
            (at start (free ?m))
            (at start (without-target ?m))
            (at start (> (distance ?c) 0))
            (over all (not-recharging ?m))
        )
        :effect (and
            (at start (not (free ?m)))
            (at start (not (without-target ?m)))
            (at end (reached ?m ?c))
            (at end (free ?m))
            (at end (assign (distMover ?m) (distance ?c)))
        )
    )

    ; battery extension
    (:durative-action recharge
        :parameters (?m - mover)
        :duration (= ?duration 1)
        :condition (and 
            (over all (and (= (distMover ?m) 0)))
        )
        :effect (and 
            (at start (not (not-recharging ?m)))
            (at end (not-recharging ?m))
            (at end (assign (battery ?m) 20))
        )
    )

    ; Recharge action to compare the different implementation of the battery
    ; in macro vs no macro implementation
    
    ; (:action recharge
    ;     :parameters (?m - mover)
    ;     :precondition (and 
    ;         (= (distMover ?m) 0)
    ;         (free ?m)
    ;     )
    ;     :effect (and (assign (battery ?m) 20))
    ; )
    

)


