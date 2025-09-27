#lang htdp/isl+
(require 2htdp/universe)
(require 2htdp/image)

;; constants
(define WIDTH 400)
(define HEIGHT 400)
(define BALL-RADIUS 15)
(define BALL (circle BALL-RADIUS "solid" "red"))

;; world state
;; A world is (make-world Number Number Number Number)
;;   where (x, y) is position and (dx, dy) is velocity
(define-struct world (x y dx dy))

;; initial world: start ball in middle, moving diagonally
(define START (make-world 200 200 3 2))

;; render
(define (draw w)
  (place-image BALL (world-x w) (world-y w)
               (empty-scene WIDTH HEIGHT)))

;; update
(define (tick w)
  (let* ([x (world-x w)]
         [y (world-y w)]
         [dx (world-dx w)]
         [dy (world-dy w)]
         ;; bounce off walls: if hitting edge, reverse velocity
         [new-dx (if (or (< x BALL-RADIUS) (> x (- WIDTH BALL-RADIUS)))
                     (- dx) dx)]
         [new-dy (if (or (< y BALL-RADIUS) (> y (- HEIGHT BALL-RADIUS)))
                     (- dy) dy)])
    (make-world (+ x new-dx)
                (+ y new-dy)
                new-dx
                new-dy)))

;; main
(big-bang START
          [on-tick tick]
          [to-draw draw])