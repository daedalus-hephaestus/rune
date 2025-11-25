#+feature dynamic-literals
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
}

unload_textures :: proc () {
	for i in img {
		when ODIN_DEBUG {
			fmt.printfln("unloading texture: %v", i)
		}

		rl.UnloadTexture(img[i].texture)
	}
}
