#[module with game objects]#

from runtime import screenWidth, screenHeight
from loader import loadShawarmas

import raylib
import random

type Shawarma* = object
  position*: Vector2
  alive*: bool

var shawarmasCount = 10
var shawarmas: seq[Shawarma] = @[]

proc initShawarmas*(CollisionMask: Image): seq[Shawarma] =
  randomize()

  var shawarmas: seq[Shawarma] = @[]
  let foodie = loadShawarmas()
  let
    objWidth = foodie.width
    objHeight = foodie.height
    maskWidth = CollisionMask.width
    maskHeight = CollisionMask.height
  var attempts: uint = 0
  
  for _ in 0..<shawarmasCount:
    var validPos = false
    # var attempts: uint = 0
    var shawarmaPos: Vector2

    while not validPos: # and attempts < 100 (might add)
      inc attempts
      shawarmaPos = Vector2(
        x: rand(10.0..float64(screenWidth - objWidth)),
        y: rand(10.0..float64(screenHeight - objHeight))
      )

      let px = int32(shawarmaPos.x).clamp(0, maskWidth - 1)
      let py = int32(shawarmaPos.y).clamp(0, maskHeight - 1)
      let pixel: Color = getImageColor(CollisionMask, px, py)

      if pixel.r == 255 and pixel.g == 255 and pixel.b == 255: validPos = true

    shawarmas.add(Shawarma(position: shawarmaPos, alive: true))

  traceLog(INFO, "I DID THIS FOR " & $attempts & " TIMES!!")
  return shawarmas
