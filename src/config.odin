package main

import rl "vendor:raylib"

WINDOW_HEIGHT :: 800
WINDOW_WIDTH :: 600
TARGET_FPS :: 60

WINDOW :: Window{"kedi", WINDOW_WIDTH, WINDOW_HEIGHT, TARGET_FPS, rl.ConfigFlags{.WINDOW_RESIZABLE, .WINDOW_HIGHDPI}}

Window :: struct {
  name: cstring,
  width: i32,
  height: i32,
  fps: i32,
  config_flags: rl.ConfigFlags,
}

