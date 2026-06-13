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
  setConfigFlags(flags(WindowResizable, WindowHighdpi))
  initWindow(screenWidth, screenHeight, "KEDI-OYUN")
  initAudio()
  defer:
    closeAudio()
    closeWindow()

  let target = loadRenderTexture(screenWidth, screenHeight)
  setTextureFilter(target.texture, Bilinear)

  block fitWindow:
    let m = getCurrentMonitor()
    let monW = getMonitorWidth(m).float32
    let monH = getMonitorHeight(m).float32
    var fit = min(monW / screenWidth.float32, monH / screenHeight.float32)
    if fit > 1.0f: fit = 1.0f
    fit *= 0.9f                        
    let winW = int32(screenWidth.float32  * fit)
    let winH = int32(screenHeight.float32 * fit)
    setWindowSize(winW, winH)
    setWindowPosition(int32((monW - winW.float32) * 0.5f),
                    int32((monH - winH.float32) * 0.5f))
    
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
                  
    beginTextureMode(target)
    clearBackground(BLACK)

    drawTexture(GameBackground, Vector2(x: 0.0, y: 0.0), WHITE)
    drawTexture(PlayerFigure, playerPosition, 0.0f, 0.25f, WHITE)
    displayFPS(screenWidth - 110, 25, RED)
    drawText("Score: " & $playerScore, 20, 20, 20, RED)

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
      shawarmas = initShawarmas(CollisionMask, Eatables)
      spawnage = true

    if spawnage:
      for sh in shawarmas:
        if sh.alive:
          drawTexture(Eatables, sh.position, WHITE)

    endTextureMode()

    beginDrawing()
    clearBackground(BLACK)
    let
      winW = getScreenWidth().float32
      winH = getScreenHeight().float32
      scale = min(winW / screenWidth.float32, winH / screenHeight.float32)
      drawW = screenWidth.float32 * scale
      drawH = screenHeight.float32 * scale
    drawTexture(
      target.texture,
      Rectangle(x: 0.0f, y: 0.0f,
                width: screenWidth.float32, height: -screenHeight.float32),
      Rectangle(x: (winW - drawW) * 0.5f, y: (winH - drawH) * 0.5f,
                width: drawW, height: drawH),
      Vector2(x: 0.0f, y: 0.0f),
      0.0f,
      WHITE)
    endDrawing()

main()
