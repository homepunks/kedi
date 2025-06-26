#[module for extra function definitions
  and global variables used in the game]#

import raylib

const
  screenWidth*: int32  = 1920
  screenHeight*: int32 = 1080
  constDialogTimeout*: float64 = 5.0f # seconds
  constSpawnageTimeout*: float64 = 7.5f # seconds

var
  dialogTimeout*: float64 = constDialogTimeout
  dialog*: int = 1

  spawnageTimeout*: float64 = constSpawnageTimeout
  spawnage*: bool = false

proc isItWalkable*(pos: ptr Vector2, CollisionMask: Image, figureWidth: float64, figureHeight: float64): bool =
  if pos.x < 0: pos.x = 0
  if pos.y < 0: pos.y = 0
  if (pos.x + figureWidth) > float64(screenWidth): pos.x = float64(screenWidth) - figureWidth
  if (pos.y + 1.75 * figureHeight) > float64(screenHeight): pos.y = float64(screenHeight) - 1.75 * figureHeight
        #[     ^                                                          ^      ]#
        #[     |                                                          |      ]#
        #[ HARDCODED                                                  HARDCODED  ]#

  let posTummy = Vector2(
    x: pos.x + figureWidth * 0.5,
    y: pos.y + figureHeight * 0.8
  )
                                                         
  let pixel: Color = getImageColor(CollisionMask, int32(posTummy.x), int32(posTummy.y))
  if pixel.r == 0:
    return false
  
  return true


proc displayFPS*(posX: int32, posY: int32, color: Color): void =
  let FPSInfo: string = "FPS: " & $getFPS()
  drawText(FPSInfo, posX, posY, 20, color)
  discard

proc msg1Controls*(): void =  
  let text: string = "Use WASD to move"
  let textSize: int32 = measureText(text, 40)
  let textPos = Vector2(
    x: float64((screenWidth - textSize))/2.0,
    y: 100.0f
  )
      
  var fadeColor: Color = GOLD
  fadeColor.a = uint8(dialogTimeout * 51)
  drawText(text, int32(textPos.x), int32(textPos.y), 40, fadeColor)
  discard

proc msg2Eat*(): void =
  let text: string = "Eat all foodies to gain power"
  let textSize: int32 = measureText(text, 40)
  let textPos = Vector2(
    x: float64((screenWidth - textSize))/2.0,
    y: 100.0f
  )

  var fadeColor: Color = GOLD
  fadeColor.a = uint8(dialogTimeout * 51)
  drawText(text, int32(textPos.x), int32(textPos.y), 40, fadeColor)
