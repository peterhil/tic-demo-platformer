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

;; <COVER>
;; 000:6f5000007494648393160f00880077000012ffb0e45445353414055423e2033010000000129f40402000ff00c2000000000f00880078a1c1c27a0f074f4f4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080ff001080c1840b0a1c388031a2c58c0b1a3c780132a4c9841b2a5cb88133a6cd8c1b3a7cf80234a8c1942b4a9c398235aac59c2b5abc790336acc9943b6adcb98337aecd9c3b7afcf904186081a447860d3a845461d2a94b9a3dc8b498e3d9a45126453a553ba65387530c6dfab5bb28d1b455c29d3b94dc2ad5bc6bdabd7b073eacd9b47beaddbb873faeddbc7bfafdfb0830b0e1c48b0b1e3c8831b2e5cc8b1b362cd532b4e5a025d65c9c893336ebba9b3b4df86992a7e1dd99339ecc59fa26c3dca32b9e6dea14baeb80bb6f7eab6b34f64dd21377de7debf6774ed11387b60e6c3574d5d6cf432f0eac923de6e4af1b5fbe8d3bb6fdecdbbb7ffe0e3cb8fff1f4e99f27bb4cf17a77bbeb17b76bfe717c74b3f317d72b7ff07e70bbfb07ff0b3bd67ff9653069760e1880628a0e28c0638e0e3801648212c450e956b9978adf4512e7fbd47a9905102f571a7891af4b1e8532a54e91887e5f592e565a96812ee5f2a8613a9833ae553e44b2ac8d2a88d1aa873e4842235442a893e1955d98a4ad4c463943d3905ac425e4941629656a585e37859b7b52a7f5af7162d555ac556e2936e067669596a06b6e45f62b7d66c5176b55763577ea597ee44d946842c6c56f9d52080828928ef84060946e1a88665b32d9c8a47f5d3a0754a2921a7c91a69a75cf92a37d6a2c52a586694a69a6ae9a8a6aaaaeaaca6baeaae9d72a0c4286973be945be877b6949b687bbe84dbe77fb6841c6773cac64d1da1bada9c2eabcaeadca690a2b87924bb9a550a27a8363a74d5b8d634cda4b64a35fde343e66b3d2255ea7b7d28b1a2abbe29bfea9b1e2e91faab1daf87ee6b5f2349e2f4b7a25bfa26d59004071c40fbae4e5560b1c807d430f2c7073c33d3c01b4c31b2c01b00613598175cb1f591556ca1f7cf215cb0be7cd6aca2facc27bce2fbc037cc23fcc437dc63fdc837eca3fecc37fce3ffc0470d24f0d4471d64f1d84f1d10100b3
;; </COVER>

