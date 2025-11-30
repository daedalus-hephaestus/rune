package rune

import rl "vendor:raylib"
import "core:fmt"

SCALE :: 4

window :: proc(w, h: i32) {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .WINDOW_MAXIMIZED})
	rl.InitWindow(w, h, "rune")

	load_player(PLAYER_NAME)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		draw_loaded_chunks()

		rl.EndDrawing()
	}

	destroy_all_chunks()
	destroy_assets()
	rl.CloseWindow()
}
