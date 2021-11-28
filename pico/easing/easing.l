(symbols 'easing 'pico)

(load "@lib/math.l")

# math.l defaults to scale 6 (single-float precision)
(scl 15)

(default
  f*
    '(@
      (let X (next)
        (while (next)
          (setq X (*/ X @ 1.0)))))
  f/
    '(@
      (let X (next)
        (while (next)
          (setq X (*/ 1.0 X @))))))    
    
          
# X = abs progress of animation
# where 0 is the start and 1.0 is the end of the animation

# sine

(de ease-in-sine (X)
  # 1.0 - cos((X * pi) / 2.0)
  (-
    1.0
    (cos
      (f/
        (f* X pi)
        2.0))))

(de ease-out-sine (X)
  # sin((X * pi) / 2.0)
  (sin
    (f/
      (f* X pi)
      2.0)))

(de ease-io-sine (X)
  # -(cos(pi * X) - 1.0) / 2
  (f/
    (-
      (-
        (cos (f* pi X))
        1.0))
    2.0))


# quad

(de ease-in-quad (X)
  # X * X
  (f* X X))

(de ease-out-quad (X)
  # 1.0 - (1 - X) * (1 - X)
  (-
    1.0
    (*
      (- 1.0 X)
      (- 1.0 X))))

(de ease-io-quad (X)
  # X < 0.5 ? 2.0 * X * X : 1.0 - pow(-2 * X + 2, 2.0) / 2
  (if (< X 0.5)
      (f* 2.0 X X)
      (- 1.0
        (f/
          (pow
            (+ (f* -2 X) 2.0)
            2.0)
          2.0))))


# cubic

(de ease-in-cubic (X)
  # X * X * X
  (f* X X X))

(de ease-out-cubic (X)
  # 1.0 - pow(1 - X, 3.0)
  (-
    1.0
    (pow (- 1.0 X) 3.0)))

(de ease-io-cubic (X)
  # X < 0.5 ? 4 * X * X * X : 1.0 - pow(-2 * X + 2, 3.0) / 2
  (if (< X 0.5)
      (f* 4.0
        (f* X
          (f* X X)))
      (-
        1.0
        (f/
          (pow
            (+ (f* -2 X) 2.0)
            3.0)
          2.0))))


# quart

(de ease-in-quart (X)
  # X * X * X * X
  (f* X X X X))

(de ease-out-quart (X)
  # 1.0 - pow(1 - X, 4.0)
  (-
    1.0
    (pow (- 1.0 X) 4.0)))

(de ease-io-quart (X)
  # X < 0.5 ? 8 * X * X * X * X : 1.0 - pow(-2 * X + 2, 4.0) / 2
  (if (< X 0.5)
      (f* 8.0 X X X X)
      (-
        1.0
        (f/
          (pow
            (+ (f* -2 X) 2.0)
            4.0)
          2.0))))


# quint

(de ease-in-quint (X)
  # X * X * X * X * X
  (f* X X X X X))

(de ease-out-quint (X)
  # 1.0 - pow(1 - X, 5)
  (-
    1.0
    (pow (- 1.0 X) 5.0)))

(de ease-io-quint (X)
  # X < 0.5 ? 16 * X * X * X * X * X : 1.0 - pow(-2 * X + 2, 5) / 2
  (if (< X 0.5)
      (f* 16.0 X X X X X)
      (-
        1.0
        (f/
          (pow
            (+ (f* -2 X) 2.0)
            5.0)
          2.0))))


# exp

(de ease-in-exp (X)
  # X === 0 ? 0 : pow(2, 10 * X - 10)
  (if (= X 0.0)
      @
      (pow
        2.0
        (- (f* 10.0 X) 10.0))))


(de ease-out-exp (X)
  # X === 1.0 ? 1.0 : 1.0 - pow(2, -10 * X)
  (if (= X 1.0)
      @
      (pow
        2.0
        (f* -10 X))))


(de ease-io-exp (X)
  # X === 0
  # ? 0
  # : X === 1.0
  # ? 1.0
  # : X < 0.5 ? pow(2, 20 * X - 10) / 2
  # : (2.0 - pow(2, -20 * X + 10)) / 2
  (cond
    ((= X 0.0) @)
    ((= X 1.0) @)
    ((< X 0.5)
      (pow
        2.0
        (f/
          (- (f* 20.0 X) 10.0)
          2.0)))
    (T
      (f/
        (-
          2.0
          (pow
            2.0
            (+ (f* -20.0 X) 10.0)))
        2.0))))


# circ

(de ease-in-circ (X)
  # 1.0 - sqrt(1 - pow(X, 2.0))
  (-
    1.0
    (sqrt
      (-
        1.0
        (pow X 2.0)))))

(de ease-out-circ (X)
  # sqrt(1 - pow(X - 1.0, 2.0))
  (-
    1.0
    (pow
      (- X 1.0)
      2.0)))

(de ease-io-circ (X)
  # X < 0.5
  # ? (1 - sqrt(1 - pow(2.0 * X, 2.0))) / 2
  # : (sqrt(1 - pow(-2 * X + 2, 2.0)) + 1.0) / 2
  (if (< X 0.5)
      (f/
        (-
          1.0
          (sqrt
            (-
              1.0
              (pow
                (f* 2.0 X)
                2.0))))
        2.0)
      (f/
        (sqrt
          (-
            1.0
            (pow
              (+ (f* -2.0 X) 2.0)
              2.0)))
        2.0)))


# back

(def 'FB-1 1.70158)
(def 'FB-3 (+ FB-1 1.0))
(def 'FB-2 (f* FB-1 1.525))

(de ease-in-back (X)
  # const c1 = 1.70158
  # const c3 = c1 + 1.0
  # c3 * X * X * X - c1 * X * X
  (-
    (f* FB-3 X X X)
    (f* FB-1 X X)))

(de ease-out-back (X)
  # const c1 = 1.70158
  # const c3 = c1 + 1.0
  # 1.0 + c3 * pow(X - 1.0, 3.0) + c1 * pow(X - 1.0, 2.0)
  (+
    1.0
    (*
      FB-3
      (pow (- X 1.0) 3.0))
    (*
      FB-1
      (pow (- X 1.0) 2.0))))

(de ease-io-back (X)
  # const c1 = 1.70158
  # const c2 = c1 * 1.525
  # X < 0.5
  # ? (pow(2.0 * X, 2.0) * ((c2 + 1.0) * 2.0 * X - c2)) / 2
  # : (pow(2.0 * X - 2, 2.0) * ((c2 + 1.0) * (X * 2.0 - 2.0) + c2) + 2.0) / 2
  (if (< X 0.5)
      (f/
        (*
          (pow
            (f* 2.0 X)
            2.0)
          (-
            (*
              (+ FB-2 1.0)
              2.0
              X)
            FB-2))
        2.0)
      (f/
        (+
          (*
            (pow
              (- (f* 2.0 X) 2.0)
              2.0)
            (+
              (*
                (+ FB-2 1.0)
                (-
                  (f* X 2.0)
                  2.0))
              FB-2))
          2.0)
        2.0)))


# elastic

(def 'FE-4 (f/ (f* 2.0 pi) 3.0))
(def 'FE-5 (f/ (f* 2.0 pi) 4.5))

(de ease-in-elastic (X)
  # const c4 = (2.0 * Math.PI) / 3
  # X === 0
  # ? 0
  # : X === 1.0
  # ? 1.0
  # : -pow(2, 10 * X - 10) * sin((X * 10 - 10.75) * c4.0)
  (cond
    ((= X 0.0) @)
    ((= X 1.0) @)
    (T
      (*
        (-
          (pow
            2.0
            (-
              (f* 10.0 X)
              10.0)))
        (sin
          (*
            (-
              (f* X 10.0)
              10.75)
            FE-4))))))

(de ease-out-elastic (X)
  # const c4 = (2.0 * Math.PI) / 3
  # X === 0
  # ? 0
  # : X === 1.0
  # ? 1.0
  # : pow(2, -10 * X) * sin((X * 10 - 0.75) * c4.0) + 1.0
  (cond
    ((= X 0.0) @)
    ((= X 1.0) @)
    (T
      (+
        (*
          (pow
            2.0
            (f* -10.0 X))
          (sin
            (*
              (-
                (f* X 10.0)
                0.75)
              FB-4)))
        1.0))))

(de ease-io-elastic (X)
  # const c5 = (2.0 * Math.PI) / 4.5
  # X === 0
  # ? 0
  # : X === 1.0
  # ? 1.0
  # : X < 0.5
  # ? -(pow(2, 20 * X - 10) * sin((20 * X - 11.125) * c5)) / 2
  # : (pow(2, -20 * X + 10) * sin((20 * X - 11.125) * c5)) / 2.0 + 1
  (cond
    ((= X 0.0) @)
    ((= X 1.0) @)
    ((< X 0.5)
      (f/
        (-
          (*
            (pow
              2.0
              (-
                (f* 20.0 X)
                10.0))
            (sin
              (*
                (-
                  (f* X 20.0)
                  11.125)
                FB-5))))
        2.0))
    (T
      (+
        (f/
          (*
            (pow
              2.0
              (+
                (f* -20.0 X)
                10.0))
            (sin
              (*
                (-
                  (f* X 20.0)
                  11.125)
                FB-5)))
          2.0)
        1.0))))


# bounce

(def 'FB-6 7.5625)
(def 'FB-7 2.75)

(de ease-in-bounce (X)
  # 1.0 - easeOutBounce(1 - X)
  (-
    1.0
    (ease-out-bounce
      (- 1.0 X))))

(de ease-out-bounce (X)
  # const n1 = 7.5625
  # const d1 = 2.75
  # if (X < 1.0 / d1)
  #     # n1 * X * X
  # else if (X < 2.0 / d1)
  #     # n1 * (X -= 1.5 / d1) * X + 0.75
  # else if (X < 2.5 / d1)
  #     # n1 * (X -= 2.25 / d1) * X + 0.9375
  # else
  #     # n1 * (X -= 2.625 / d1) * X + 0.984375
  (cond
    ((< X (f/ 1.0 FB-7))
      (f* FB-6 X X))
    ((< X (f/ 2.0 FB-7))
      (+
        (*
          FB-6
          (dec 'X (f/ 1.5 FB-7))
          X)
        0.75))
    ((< X (f/ 2.5 FB-7))
      (+
        (*
          FB-6
          (dec 'X (f/ 2.25 FB-7))
          X)
        0.9375))
    (T
      (+
        (*
          FB-6
          (dec 'X (f/ 2.625 FB-7))
          X)
        0.984375))))


(de ease-io-bounce (X)
  # X < 0.5
  # ? (1 - easeOutBounce(1 - 2.0 * X)) / 2
  # : (1 + easeOutBounce(2.0 * X - 1.0)) / 2
  (if (< X 0.5)
      (f/
        (-
          1.0
          (ease-out-bounce
            (-
              1.0
              (f* 2.0 X))))
        2.0)
      (f/
        (+
          1.0
          (ease-out-bounce
            (-
              (f* 2.0 X)
              1.0)))
        2.0)))


# for testing
(de ease (Fn Inc)
  (t
    # with Scl=6 means 6000 loops
    (for (I 0.0 (>= 1.0 I) (inc 'I Inc))
      (prinl
        (text
          "@1 @2"
          (format I *Scl)
          (format (Fn I) *Scl))))))
