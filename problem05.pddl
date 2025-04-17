(define 
    (problem problem05) 
    (:domain warehouse)
    (:objects 
        crateA crateB - crate
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
        (= (distance crateA) 10)
        (= (fragile crateA) 0)
        (= (group crateA) 0)
        (= (carried crateA) 0)
        (= (at-loading-bay crateA) 0)

        ; crateB
        (= (weight crateB) 20)
        (= (distance crateB) 20)
        (= (fragile crateB) 0)
        (= (group crateB) 1)
        (= (carried crateB) 0)
        (= (at-loading-bay crateB) 0)
    )

    (:goal (and
        (loaded crateA)
        (loaded crateB)
        )
    )
)