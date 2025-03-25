(define (problem problem05) (:domain warehouse)
(:objects crateA crateB - crate
    moverA moverB - mover
    loaderA - loader
)

(:init
    (free moverA) (free moverB)
    (free_loader loaderA)
    ; crateA
    (= (weight crateA) 70)
    (= (distance crateA) 10)

    ; crateB
    (= (weight crateB) 20)
    (= (distance crateB) 20)
)

(:goal (and
    (loaded crateA)
    (loaded crateB)
))

)
