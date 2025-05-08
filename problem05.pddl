(define 
    (problem problem05) 
    (:domain warehouse)
    (:objects 
        crateA crateB - crate
        moverA moverB - mover
        loaderA loaderB - loader        
        group0 groupA - groupClass
    )

    (:init
        (free moverA) (free moverB)
        (without-target moverA) (without-target moverB)
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
        (= (groupMember groupA) 1)

        (= (groupId group0) 0)
        (= (groupId groupA) 1)
        
        ; crateA
        (= (weight crateA) 70)
        (= (distance crateA) 10)
        (= (fragile crateA) 0)
        (= (group crateA) 0)
        (= (carried crateA) 0)


        ; crateB
        (= (weight crateB) 20)
        (= (distance crateB) 20)
        (= (fragile crateB) 0)
        (= (group crateB) 1)
        (= (carried crateB) 0)
    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        )
    )
)