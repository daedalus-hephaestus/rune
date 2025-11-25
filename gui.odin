package rune

import rl "vendor:raylib"
import "core:fmt"

window :: proc(w, h: i32) {
	rl.SetTraceLogLevel(.ERROR)
	rl.InitWindow(w, h, "rune")

	load_player(PLAYER_NAME)
	fmt.println(img)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)
		rl.EndDrawing()
	}

	destroy_assets()
	rl.CloseWindow()
}
