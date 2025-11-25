package rune

import "core:fmt"

Player :: struct {
	name: string,
	location: Location,
	realm: string
}

load_player :: proc(name: string) {
	save_file := fmt.aprintf("save/%v.json", name)
	defer delete(save_file)

	player = load_json(save_file, Player)
	read_json_dir(JSON_PATH)
}
