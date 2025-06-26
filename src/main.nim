import raylib
from loader import GameAssets, loadAssets
from objects import Shawarma, initShawarmas
from audio import
  initAudio,
  updateAudio,
  closeAudio,
  
  eatSound,
  meowSound
from runtime import
  isItWalkable,       #[FUNC: check if the player can move on (x,y)]#
  displayFPS,   
  
  msg1Controls,       #[FUNC: show message n1 - explain the controls]#
  msg2Eat,

  screenWidth,
  screenHeight,
  
  constDialogTimeOut, #[CONST: timeout for all messages   ]#
  dialogTimeout,      #[MUT: remaining time of the message]#
  dialog,             #[MUT: dialog status                ]#

  spawnageTimeout,    #[MUT: countdown until spawnage starts]#
  spawnage            #[MUT: spawnage status                ]#

proc main(): void =
  initWindow(screenWidth, screenHeight, "KEDI-OYUN")
  initAudio()
  defer:
    closeAudio()
    closeWindow()
    
  let assets: GameAssets = loadAssets()
  let
    GameBackground = assets.background
    CollisionMask = assets.borders
    PlayerFigure = assets.player
    Eatables = assets.boosts
    
  var playerPosition = Vector2(
    x: 200.0f,
    y: 100.0f
  )
  
  var
    oldPlayerPosition: Vector2 = playerPosition
    scaledFigureWidth: float64  = float64(PlayerFigure.width) * 0.25
    scaledFigureHeight: float64 = float64(PlayerFigure.height) * 0.25
    playerScore: int = 0
    
    shawarmas: seq[Shawarma] = @[]

    playerStep: float64 = 0.35

    meowSoundPlay = false
    
  dialog = 1
  
  while not windowShouldClose():
    updateAudio()
    oldPlayerPosition = playerPosition
    if (isKeyDown(W)): playerPosition.y -= playerStep
    if (isKeyDown(A)): playerPosition.x -= playerStep
    if (isKeyDown(S)): playerPosition.y += playerStep
    if (isKeyDown(D)): playerPosition.x += playerStep

    if not isItWalkable(addr playerPosition, CollisionMask, scaledFigureWidth, scaledFigureHeight):
      playerPosition = oldPlayerPosition

    let playerRect = Rectangle(
      x: playerPosition.x,
      y: playerPosition.y,
      width: scaledFigureWidth,
      height: scaledFigureHeight
    )
    
    for i in 0..<shawarmas.len:
      if shawarmas[i].alive:
        let shawarmaRect = Rectangle(
          x: shawarmas[i].position.x,
          y: shawarmas[i].position.y,
          width: float64(Eatables.width),
          height: float64(Eatables.height)
        )

        if checkCollisionRecs(playerRect, shawarmaRect):
          shawarmas[i].alive = false
          playSound(eatSound)
          inc(playerScore)

          if playerScore == shawarmas.len and not meowSoundPlay:
            playSound(meowSound)
            meowSoundPlay = true
                  
    beginDrawing()
    defer: endDrawing()

    drawTexture(GameBackground, Vector2(x: 0.0, y: 0.0), WHITE)
    drawTexture(PlayerFigure, playerPosition, 0.0f, 0.25f, WHITE)
    displayFPS(screenWidth - 110, 25, RED)
    drawText("Score: " & $playerScore, 20, 20, 20, RED)

    # if dialogTimeout <= 0: dialog = false
    # if dialog: dialogTimeout -= getFrameTime()
    # msg1Controls()
    # msg2Eat()

    if dialog > 0:
      case dialog
      of 1: msg1Controls()
      of 2: msg2Eat()
      else: discard

      dialogTimeout -= getFrameTime()
      if dialogTimeout <= 0:
        inc dialog
        if dialog > 2:
          dialog = 0
        else:
          dialogTimeout = constDialogTimeout
            
    spawnageTimeout -= getFrameTime()
    if spawnageTimeout < 0 and not spawnage:
      shawarmas = initShawarmas(CollisionMask)
      spawnage = true

    if spawnage:
      for sh in shawarmas:
        if sh.alive:
          drawTexture(Eatables, sh.position, WHITE)

main()
