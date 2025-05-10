(define 
    (problem problem3) 
    (:domain warehouse)
    (:objects 
        crateA crateB crateC crateD - crate
        moverA moverB - mover
        loaderA - loader        
        group0 groupA - groupClass
    )

    (:init
        (free moverA) (free moverB)
        (without-target moverA) (without-target moverB)
        (free_loader loaderA)

        ; crateA
        (= (weight crateA) 70)
        (= (distance crateA) 20)
        (= (fragile crateA)0)
        (= (group crateA) 1)
        (not-carried crateA)

        ; crateB
        (= (weight crateB) 80)
        (= (distance crateB) 20)
        (= (fragile crateB)1)
        (= (group crateB) 1)
        (not-carried crateB)

        ; crateC
        (= (weight crateC) 60)
        (= (distance crateC) 30)
        (= (fragile crateC)0)
        (= (group crateC) 1)
        (not-carried crateC)

        ; crateD
        (= (weight crateD) 30)
        (= (distance crateD) 10)
        (= (fragile crateD)0)
        (= (group crateD) 0)
        (not-carried crateD)
    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        (loaded crateC)
        (loaded crateD)
        )
    )
)
