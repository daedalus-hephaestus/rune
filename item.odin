package rune

import "core:fmt"

Item :: struct {
	name: cstring,
	img: cstring
}

load_item :: proc(i: ^Item) {
	img_loaded := img[i.img].texture.id != 0

	if !img_loaded {
		path := fmt.aprintf("json/img/%v.json", i.img)
		defer delete(path)

		data := load_json(path, Image)
		load_img(&data)
	}
}
