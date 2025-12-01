package rune

import "core:fmt"
import rl "vendor:raylib"

unloaded_chunks: map[cstring]map[rl.Vector3]Chunk
loaded_chunks: map[rl.Vector3]Chunk
tiles: map[cstring]Tile

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

load_tile :: proc(t: ^Tile) {
	load_img_name(t.img)
	tiles[t.name] = t^
}

destroy_tiles :: proc() {
	delete(tiles)
}

preload_chunk :: proc(c: ^Chunk) {

	realm, has := &unloaded_chunks[c.realm]
	if !has {
		unloaded_chunks[c.realm] = make(map[rl.Vector3]Chunk)
		realm = &unloaded_chunks[c.realm]
	}

	for t in c.tilemap.tiles {
		_, has := tiles[t]
		if !has {
			path := fmt.aprintf("json/tile/%v.json", t)
			defer delete(path)

			data := load_json(path, Tile)
			load_tile(&data)
		}
	}

	realm[c.coords] = c^

}

load_chunk :: proc(c: Chunk) {
}

draw_chunk :: proc(c: Chunk) {
	for row, y in c.tilemap.ground {
		for tile, x in row {
			if tile > 0 {
				name := c.tilemap.tiles[tile - 1]
				i := img[tiles[name].img]
				rl.DrawTextureEx(i.texture, {f32(x), f32(y)} * 16 * SCALE, 0, SCALE, rl.WHITE)
			}
		}
	}
}

draw_loaded_chunks :: proc() {
}

destroy_chunk :: proc(c: ^Chunk) {
}

destroy_all_chunks :: proc() {
	for realm in unloaded_chunks {
		for _, &c in unloaded_chunks[realm] do destroy_chunk(&c)
		delete(unloaded_chunks[realm])
	}
	delete(unloaded_chunks)
	delete(loaded_chunks)
}
