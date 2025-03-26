(define (problem problem1) (:domain warehouse)
(:objects crateA crateB crateC - crate
    moverA moverB - mover
    loaderA - loader
)

(:init
    (free moverA) (free moverB)
    (free_loader loaderA)
    
    ; crateA
    (= (weight crateA) 70)
    (= (distance crateA) 10)
    (= (fragile crateA)0)
    (= (group crateA) 0)
    (on-floor crateA)


    ; crateB
    (= (weight crateB) 20)
    (= (distance crateB) 20)
    (= (fragile crateB)1)
    (= (group crateB) 1)
    (on-floor crateB)

    ; crateC
    (= (weight crateC) 20)
    (= (distance crateC) 20)
    (= (fragile crateC)0)
    (= (group crateC) 1)
    (on-floor crateC)
)

(:goal (and
    (loaded crateA)
    (loaded crateB)
    (loaded crateC)
))

)
