#+feature dynamic-literals
package rune

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

JSON_PATH :: "/home/daedalus/dev/odin_projects/rune/json"
PLAYER_NAME :: "daedalus"

DIMS := [2]i32{ 640, 360 }

player : Player
img : map[cstring]Image
item : map[cstring]Item
tiles: map[cstring]Tile
unloaded_chunks: map[cstring]map[rl.Vector3]Chunk

main :: proc() {

	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				for _, entry in track.allocation_map {
					fmt.eprintf("%v leaked %v bytes\n", entry.location, entry.size)
				}
			}
			if len(track.bad_free_array) > 0 {
				for entry in track.bad_free_array {
					fmt.eprintf("%v bad free at %v\n", entry.location, entry.memory)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	window(DIMS.x, DIMS.y) 
}
