package main

import rl "vendor:raylib"

WINDOW_TITLE :: "kedi"
WINDOW_FLAGS :: rl.ConfigFlags{.WINDOW_RESIZABLE, .WINDOW_HIGHDPI}
TARGET_FPS   :: 60

VIRT_WIDTH  :: 1920
VIRT_HEIGHT :: 1080

WINDOW_MARGIN :: 0.9


// Window :: struct {
//   name: cstring,
//   width: i32,
//   height: i32,
//   fps: i32,
//   config_flags: rl.ConfigFlags,
// }

