(define 
    (problem problem2) 
    (:domain warehouse)
    (:objects 
        crateA crateB crateC crateD - crate
        moverA moverB - mover
        loaderA - loader
    )

    (:init
        (free moverA) (free moverB)
        (without-target moverA) (without-target moverB)
        (free_loader loaderA)
        (= (last_loaded_group) 0) ; Initialize with no group loaded
        (= (groupAmembers) 2)  
        (= (groupBmembers) 2)

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
