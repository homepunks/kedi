package main

import rl "vendor:raylib"

main :: proc() {
  rl.SetConfigFlags(WINDOW_FLAGS)
  rl.InitWindow(VIRT_WIDTH, VIRT_HEIGHT, WINDOW_TITLE)
  defer rl.CloseWindow()

  fit_to_monitor()
  rl.SetTargetFPS(TARGET_FPS)

  target := rl.LoadRenderTexture(VIRT_WIDTH, VIRT_HEIGHT)
  defer rl.UnloadRenderTexture(target)
  rl.SetTextureFilter(target.texture, .BILINEAR)

  for !rl.WindowShouldClose() {
    rl.BeginTextureMode(target)
    rl.ClearBackground(rl.SKYBLUE)
    rl.EndTextureMode()

    rl.BeginDrawing()
    rl.ClearBackground(rl.PINK)
    present_scaled(target)
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

present_scaled :: proc(target: rl.RenderTexture2D) {
  sw := f32(rl.GetScreenWidth())
  sh := f32(rl.GetScreenHeight())
  scale := min(sw/VIRT_WIDTH, sh/VIRT_HEIGHT)

  dw := VIRT_WIDTH * scale
  dh := VIRT_HEIGHT * scale
  dx := (sw - dw) / 2
  dy := (sh - dh) / 2

  src := rl.Rectangle{0, 0, VIRT_WIDTH, -VIRT_HEIGHT}
  dst := rl.Rectangle{dx, dy, dw, dh}
  rl.DrawTexturePro(target.texture, src, dst, {0, 0}, 0, rl.WHITE)
}
