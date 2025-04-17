(define 
    (problem problem3) 
    (:domain warehouse)
    (:objects 
        crateA crateB crateC crateD - crate
        moverA moverB - mover
        loaderA loaderB - loader
    )

    (:init
        (free moverA) (free moverB)
        (without-target moverA) (without-target moverB)
        (free_loader loaderA) (free_loader loaderB)

        ; loader
        (= (arm loaderA) 0)
        (= (arm loaderB) 1)
        
        ; crateA
        (= (weight crateA) 70)
        (= (distance crateA) 20)
        (= (fragile crateA)0)
        (= (group crateA) 1)
        (= (carried crateA) 0)
        (= (at-loading-bay crateA) 0)

        ; crateB
        (= (weight crateB) 80)
        (= (distance crateB) 20)
        (= (fragile crateB)1)
        (= (group crateB) 1)
        (= (carried crateB) 0)
        (= (at-loading-bay crateB) 0)

        ; crateC
        (= (weight crateC) 60)
        (= (distance crateC) 30)
        (= (fragile crateC)0)
        (= (group crateC) 1)
        (= (carried crateC) 0)
        (= (at-loading-bay crateC) 0)

        ; crateD
        (= (weight crateD) 30)
        (= (distance crateD) 10)
        (= (fragile crateD)0)
        (= (group crateD) 0)
        (= (carried crateD) 0)
        (= (at-loading-bay crateD) 0)

    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        (loaded crateC)
        (loaded crateD)
        )
    )
)
