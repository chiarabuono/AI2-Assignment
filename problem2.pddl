(define 
    (problem problem2) 
    (:domain warehouse)
    (:objects 
        crateA crateB crateC crateD - crate
        moverA moverB - mover
        loaderA loaderB - loader
        groupA groupB - groupClass
    )

    (:init
        (free moverA) (free moverB)
        (without-target moverA) (without-target moverB)
        (not-recharging moverA) (not-recharging moverB)
        (free_loader loaderA) (free_loader loaderB)

        ; loader
        (= (arm loaderA) 0)
        (= (arm loaderB) 1)

        (= (battery moverA) 20)
        (= (battery moverB) 20)
        (= (distMover moverA) 0)
        (= (distMover moverB) 0)

        ; group
        (= (active-group) 0)
        (= (groupMember groupA) 2)
        (= (groupMember groupB) 2)

        (= (groupId groupA) 1)
        (= (groupId groupB) 2)
        
        ; crateA
        (= (weight crateA) 70)
        (= (distance crateA) 10)
        (= (fragile crateA)0)
        (= (group crateA) 1)
        (= (carried crateA) 0)

        ; crateB
        (= (weight crateB) 80)
        (= (distance crateB) 20)
        (= (fragile crateB)1)
        (= (group crateB) 1)
        (= (carried crateB) 0)

        ; crateC
        (= (weight crateC) 20)
        (= (distance crateC) 20)
        (= (fragile crateC)0)
        (= (group crateC) 2)
        (= (carried crateC) 0)

        ; crateD
        (= (weight crateD) 30)
        (= (distance crateD) 10)
        (= (fragile crateD)0)
        (= (group crateD) 2)
        (= (carried crateD) 0)

    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        (loaded crateC)
        (loaded crateD)
        )
    )
)
