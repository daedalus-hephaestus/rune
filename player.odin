package rune

import "core:fmt"

Player :: struct {
	name:     string,
	location: Location,
	realm:    string,
}

load_player :: proc(name: string, target: ^Player) {
	save_file := fmt.aprintf("save/%v.json", name)
	defer delete(save_file)

	target^ = load_json(save_file, Player)
	read_json_dir(JSON_PATH)
}

update_loc :: proc(p: ^Player) {

}
