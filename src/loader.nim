#[module for loading game assets]#

import raylib

type
  GameAssets* = object
    background*: Texture2D
    borders*: Image
    player*: Texture2D
    boosts*: Texture2D
    
proc loadAssets*(): GameAssets = 
  let
    Turkey: Image = loadImage("./assets/turkey_2.png")
    CollisionMask: Image = loadImage("./assets/turkey_mask_3.png")
    Kitty: Image = loadImage("./assets/kedi.png")
    Yemek: Image = loadImage("./assets/shawarmik2.png")
    
    GameBackground: Texture2D = loadTextureFromImage(Turkey)
    PlayerFigure: Texture2D = loadTextureFromImage(Kitty)
    Eatables: Texture2D = loadTextureFromImage(Yemek)
    
  return GameAssets(
    background: GameBackground,
    borders: CollisionMask,
    player: PlayerFigure,
    boosts: Eatables 
  )

proc loadShawarmas*(): GameAssets.boosts =
  let
    Yemek: Image = loadImage("./assets/shawarma.png")
    Eatables: Texture2D = loadTextureFromImage(Yemek)

  return Eatables
  
