package rune

import "core:fmt"

Item :: struct {
	name: cstring,
	img:  cstring,
}

load_item :: proc(i: ^Item, item_map: ^map[cstring]Item, img_map: ^map[cstring]Image) {
	img_loaded := img[i.img].texture.id != 0

	if !img_loaded {
		path := fmt.aprintf("json/img/%v.json", i.img)
		defer delete(path)

		data := load_json(path, Image)
		load_img(&data, img_map)
	}
}
