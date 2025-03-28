(define (problem problem1) (:domain warehouse)
(:objects crateA crateB crateC - crate
    moverA moverB - mover
    loaderA - loader
)

(:init
    (free moverA) (free moverB)
    (without-target moverA) (without-target moverB)
    (free_loader loaderA)
    
    ; crateA
    (= (weight crateA) 70)
    (= (distance crateA) 10)
    (= (fragile crateA)0)
    (= (group crateA) 0)
    (= (carried crateA) 0)


    ; crateB
    (= (weight crateB) 20)
    (= (distance crateB) 20)
    (= (fragile crateB)1)
    (= (group crateB) 1)
    (= (carried crateB) 0)

    ; crateC
    (= (weight crateC) 20)
    (= (distance crateC) 20)
    (= (fragile crateC)0)
    (= (group crateC) 1)
    (= (carried crateC) 0)
)

(:goal (and
    (loaded crateA)
    (loaded crateB)
    (loaded crateC)
))

)
