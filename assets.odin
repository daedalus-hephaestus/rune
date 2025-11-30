package rune

import "core:fmt"
import rl "vendor:raylib"

Image :: struct {
	name: cstring,
	path: cstring,
	texture: rl.Texture2D
}

img : map[cstring]Image

load_img :: proc(i: ^Image) {
	i.texture = rl.LoadTexture(i.path)
	img[i.name] = i^

	fmt.println(i.texture)
}

load_img_name :: proc(name: cstring) {
	img, has := &img[name]

	if !has {
		path := fmt.aprintf("json/img/%v.json", name)
		defer delete(path)

		data := load_json(path, Image)
		load_img(&data)
	}
}

unload_textures :: proc () {
	for i in img {
		when ODIN_DEBUG {
			fmt.printfln("unloading texture: %v", i)
		}

		rl.UnloadTexture(img[i].texture)
	}
}
