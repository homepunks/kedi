package main

import rl "vendor:raylib"

main :: proc() {
  rl.SetConfigFlags(WINDOW_FLAGS)
  rl.InitWindow(VIRT_WIDTH, VIRT_HEIGHT, WINDOW_TITLE)
  defer rl.CloseWindow()

  fit_to_monitor()
  rl.SetTargetFPS(TARGET_FPS)

  for !rl.WindowShouldClose() {
    rl.BeginDrawing()
    rl.ClearBackground(rl.PINK)
    rl.EndDrawing()
  }
}

fit_to_monitor :: proc() {
  monitor := rl.GetCurrentMonitor()
  mon_w := f32(rl.GetMonitorWidth(monitor))
  mon_h := f32(rl.GetMonitorHeight(monitor))

  fit := min(mon_w/VIRT_WIDTH, mon_h/VIRT_HEIGHT)
  if fit > 1 do fit = 1
  fit *= WINDOW_MARGIN

  win_w := i32(VIRT_WIDTH * fit)
  win_h := i32(VIRT_HEIGHT * fit)

  rl.SetWindowSize(win_w, win_h)
  rl.SetWindowPosition(
    i32((mon_w-f32(win_w)) / 2),
    i32((mon_h-f32(win_h)) / 2),
  )
  rl.ClearWindowState({.WINDOW_HIDDEN})
}
