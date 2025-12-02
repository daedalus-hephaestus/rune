package rune

import "core:fmt"
import rl "vendor:raylib"

SCALE :: 1

window :: proc(w, h: i32) {
	rl.SetTraceLogLevel(.ERROR)
	rl.InitWindow(w, h, "rune")

	load_player(PLAYER_NAME, &player)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		draw_loaded_chunks()

		rl.EndDrawing()
	}

	destroy_all_chunks(&unloaded_chunks, &loaded_chunks)
	destroy_assets(&img, &item)
	rl.CloseWindow()
}
