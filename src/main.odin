package main

import rl "vendor:raylib"

main :: proc() {
  window := Window{"kedi", 800, 600, 60, rl.ConfigFlags{.WINDOW_RESIZABLE, .WINDOW_HIGHDPI}}

  rl.SetConfigFlags(window.config_flags)
  rl.InitWindow(window.width, window.height, window.name)
  rl.SetTargetFPS(window.fps)

  for !rl.WindowShouldClose() {
    rl.BeginDrawing()
    rl.ClearBackground(rl.PINK)
    rl.EndDrawing()
  }
}
