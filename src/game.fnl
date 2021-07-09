;; title:  Platformer Demo
;; author: peterhil
;; desc:   Fennel version of trelemar’s simple demo platformer
;; input:  gamepad
;; script: fennel

(local t true)
(local f false)

(local C 8) ; cell size
(local B (- C 1)) ; block size
(local solids [1])

(local plr {:x 120 :y 68}) ; player
(local vel {:x 0 :y 0}) ; velocity
(local debugging f)

(fn addp [a b ?dx ?dy]
  "Add points with additional offsets"
  { :x (+ a.x b.x (or ?dx 0))
    :y (+ a.y b.y (or ?dy 0)) })

(fn target [?dx ?dy]
    (addp plr vel ?dx ?dy))

(fn vtarget [?dx ?dy]
    (addp plr {:x 0 :y vel.y} ?dx ?dy))

(fn decr [map key n]
  (tset map key (- (. map key) n)))

(fn incr [map key n]
  (tset map key (+ (. map key) n)))

(fn tile [p]
  "Map tile from point"
  (let [x (// p.x C)
        y (// p.y C)]
    (mget x y)))

(fn contains? [map key]
  (not (= nil (. map key))))

(fn solid? [p]
  "Is the point at solid tile?"
  (contains? solids (tile p)))

(fn collision? [p v]
  "Does player collide with a solid tile?"
  (let [nw (target 0 0) ne (target B 0)
        sw (target 0 B) se (target B B)]
    (if (solid? nw) t
        (solid? ne) t
        (solid? sw) t
        (solid? se) t
        f)))

(fn floored? [p v]
  (or (solid? (vtarget 0 C))
      (solid? (vtarget B C))))

(fn draw-player [plr ?color]
    (rect plr.x
          plr.y
          C C
          (or color 12)))

(fn _G.TIC []
    ;; Horizontal movement
    (if (btn 2) (set vel.x -1)
        (btn 3) (set vel.x 1)
        (set vel.x 0))

    ;; Collision?
    (if (collision? plr vel)
        (set vel.x 0))

    ;; Vertical movement
    (if (floored? plr vel)
        (do
         ;; fix player y position to avoid corner issue
         (set plr.y (* (// (+ plr.y vel.y) C) C))
         (set vel.y 0))
        (incr vel :y 0.2))

    ;; Jump
    (when (and (btnp 4)
               (= vel.y 0))
      (decr vel :y 2.5))

    ;; Upward collision
    (if (and (< vel.y 0)
             (or (solid? (target))
                 (solid? (target B))))
        (set vel.y 0))

    ;; Move player with velocity
    (incr plr :x vel.x)
    (incr plr :y vel.y)

    (cls)
    (map)
    (draw-player plr)

    ;; Debug
    (if debugging
        (do
         (print (.. :player:   " " plr.x ", " plr.y "\n"
                    :velocity: " " vel.x ", " vel.y "\n"
                    :tile: " " (tile plr) "\n"
                    :solid: " " (if (solid? plr) "true" "false") "\n"
                    :floored: " " (if (floored? plr vel) "true" "false") "\n"
                    )))))

;; <TILES>
;; 001:5555555555555555555555555555555555555555555555555555555555555555
;; </TILES>

;; <MAP>
;; 001:000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 004:101010100000000010000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 006:000000000000100000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 008:000000000000000010000000000000000000000000001010100000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 009:000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 010:000000000000100000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 011:000000000010101010100000000000000000000010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 013:000000000000000000101010100000000000101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 014:001010101010000000000000000010000000000000000000101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 015:000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; 016:101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; </MAP>

;; <WAVES>
;; 000:00000000ffffffff00000000ffffffff
;; 001:0123456789abcdeffedcba9876543210
;; 002:0123456789abcdef0123456789abcdef
;; </WAVES>

;; <SFX>
;; 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
;; </SFX>

;; <PALETTE>
;; 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
;; </PALETTE>

