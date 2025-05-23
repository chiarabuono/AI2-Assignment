(define 
    (problem problem4) 
    (:domain warehouse)
    (:objects 
        crateA crateB crateC crateD crateE crateF - crate
        moverA moverB - mover
        loaderA loaderB - loader
        group0 groupA groupB - groupClass
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
        (= (groupMember group0) 1)
        (= (groupMember groupA) 2)
        (= (groupMember groupB) 3)

        (= (groupId group0) 0)
        (= (groupId groupA) 1)
        (= (groupId groupB) 2)

        ; crateA
        (= (weight crateA) 30)
        (= (distance crateA) 20)
        (= (fragile crateA)0)
        (= (group crateA) 1)
        (= (carried crateA) 0)

        ; crateB
        (= (weight crateB) 20)
        (= (distance crateB) 20)
        (= (fragile crateB)1)
        (= (group crateB) 1)
        (= (carried crateB) 0)

        ; crateC
        (= (weight crateC) 30)
        (= (distance crateC) 10)
        (= (fragile crateC)1)
        (= (group crateC) 2)
        (= (carried crateC) 0)

        ; crateD
        (= (weight crateD) 20)
        (= (distance crateD) 20)
        (= (fragile crateD)1)
        (= (group crateD) 2)
        (= (carried crateD) 0)

        ; crateE
        (= (weight crateE) 30)
        (= (distance crateE) 30)
        (= (fragile crateE)1)
        (= (group crateE) 2)
        (= (carried crateE) 0)

        ; crateF
        (= (weight crateF) 20)
        (= (distance crateF) 10)
        (= (fragile crateF)0)
        (= (group crateF) 0)
        (= (carried crateF) 0)

    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        (loaded crateC)
        (loaded crateD)
        (loaded crateE)
        (loaded crateF)
        )
    )
)
