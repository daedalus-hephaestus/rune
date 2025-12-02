package rune

import "core:fmt"
import rl "vendor:raylib"

loaded_chunks: map[rl.Vector3]Chunk

TileType :: enum {
	SOLID,
	WALKABLE,
}

TileMap :: [16][16]int

Chunk :: struct {
	coords:   rl.Vector3,
	realm:    cstring,
	entities: struct {
		enemy:  []EnemyI,
		npc:    []NpcI,
		object: []ObjectI,
	},
	tilemap:  struct {
		ground: TileMap,
		upper:  TileMap,
		lower:  TileMap,
		tiles:  []cstring,
	},
}

Tile :: struct {
	name: cstring,
	img:  cstring,
	type: TileType,
}

load_tile :: proc(t: ^Tile, tile_map: ^map[cstring]Tile, img_map: ^map[cstring]Image) {
	load_img_name(t.img, img_map)
	tile_map[t.name] = t^
}

destroy_tiles :: proc(tile_map: ^map[cstring]Tile) {
	delete(tile_map^)
}

preload_chunk :: proc(
	c: ^Chunk,
	tile_map: ^map[cstring]Tile,
	img_map: ^map[cstring]Image,
	unloaded: ^map[cstring]map[rl.Vector3]Chunk,
) {

	realm, has := &unloaded[c.realm]
	if !has {
		unloaded[c.realm] = make(map[rl.Vector3]Chunk)
		realm = &unloaded[c.realm]
	}

	for t in c.tilemap.tiles {
		_, has := tile_map[t]
		if !has {
			path := fmt.aprintf("json/tile/%v.json", t)
			defer delete(path)

			data := load_json(path, Tile)
			load_tile(&data, tile_map, img_map)
		}
	}

	realm[c.coords] = c^
}

load_chunk :: proc(
	c: Chunk,
	unloaded: map[cstring]map[rl.Vector3]Chunk,
	loaded: ^map[rl.Vector3]Chunk,
) {

}

draw_chunk :: proc(c: Chunk) {
	for row, y in c.tilemap.ground {
		for tile, x in row {
			if tile > 0 {
				name := c.tilemap.tiles[tile - 1]
				i := img[tiles[name].img]
				pos := rl.Vector2({f32(x), f32(y)}) * 16 * SCALE
				rl.DrawTextureEx(i.texture, pos, 0, SCALE, rl.WHITE)
			}
		}
	}
}

draw_loaded_chunks :: proc() {
}

destroy_all_chunks :: proc(
	unloaded: ^map[cstring]map[rl.Vector3]Chunk,
	loaded: ^map[rl.Vector3]Chunk,
) {
	for realm in unloaded do delete(unloaded[realm])
	delete(unloaded^)
	delete(loaded^)
}
