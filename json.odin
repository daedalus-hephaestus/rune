package rune

import "core:fmt"
import "core:encoding/json"
import "core:os"
import str "core:strings"
import vmem "core:mem/virtual"

json_arena : vmem.Arena

read_json_dir :: proc(path: string) {

	dir, err := os.open(path)
	defer os.close(dir)

	if err != os.ERROR_NONE {
		fmt.eprintln("Could not open directory", err)
		os.exit(2)
	}

	file_info : []os.File_Info
	defer os.file_info_slice_delete(file_info)

	file_info, err = os.read_dir(dir, -1)
	if err != os.ERROR_NONE {
		fmt.eprintln("Could not read directory", err)
		os.exit(2)
	}

	for f in file_info {
		if f.is_dir {
			read_json_dir(f.fullpath)
			continue
		}

		// splits the file path, and gets the parent directory of the found json file
		split := str.split(f.fullpath, "/")
		defer delete(split)
		type := split[len(split) - 2]

		if type == "item" {
			data := load_json(f.fullpath, Item)
			load_item(&data)
		}

		if type == player.realm {
			data := load_json(f.fullpath, Chunk)
			preload_chunk(&data)
		}
	}

}

load_json :: proc(path: string, $T: typeid) -> T {
	when ODIN_DEBUG {
		fmt.printfln("Attempting to load %v", path)
	}

	res : T
	file_data, ok := os.read_entire_file(path, context.temp_allocator)
	arena_alloc := vmem.arena_allocator(&json_arena)

	err := json.unmarshal(file_data, &res, allocator = arena_alloc)
	if err != nil {
		fmt.eprintln("Unable to load json", err)
		os.exit(2)
	}

	when ODIN_DEBUG {
		fmt.printfln("SUCCESS!\n%#v", res)
	}

	return res
}

destroy_assets :: proc() {
	unload_textures()
	destroy_tiles()
	delete(img)
	vmem.arena_destroy(&json_arena)
}
