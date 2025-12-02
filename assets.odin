package rune

import "core:fmt"
import rl "vendor:raylib"

Image :: struct {
	name:    cstring,
	path:    cstring,
	texture: rl.Texture2D,
}

load_img :: proc(i: ^Image, img_map: ^map[cstring]Image) {
	i.texture = rl.LoadTexture(i.path)
	img_map[i.name] = i^
}

load_img_name :: proc(name: cstring, img_map: ^map[cstring]Image) {
	img, has := &img[name]

	if !has {
		path := fmt.aprintf("json/img/%v.json", name)
		defer delete(path)

		data := load_json(path, Image)
		load_img(&data, img_map)
	}
}

unload_textures :: proc(img_map: ^map[cstring]Image) {
	for i in img {
		when ODIN_DEBUG {
			fmt.printfln("unloading texture: %v", i)
		}

		rl.UnloadTexture(img_map[i].texture)
	}
}
