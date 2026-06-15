package main

import rl "vendor:raylib"

Asset_ID :: enum {
  Map,
  Cat,
}

ASSET_PATHS :: [Asset_ID]cstring {
  .Map = ASSET_MAP,
  .Cat = ASSET_CAT,
}

Assets :: struct {
  textures: [Asset_ID]rl.Texture2D,
}

load_assets :: proc() -> Assets {
  assets: Assets
  for path, id in ASSET_PATHS {
    assets.textures[id] = rl.LoadTexture(path) 
  }

  return assets
}

unload_assets :: proc(assets: Assets) {
  for tex in assets.textures {
    rl.UnloadTexture(tex)
  }
}
