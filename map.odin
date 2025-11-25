package rune

import "core:fmt"
import rl "vendor:raylib"

unloaded_chunks : map[cstring][dynamic]Chunk

TileType :: enum {
	SOLID,
	WALKABLE
}

Chunk :: struct {
	coords: rl.Vector3,
	realm: cstring,
	entities: struct {
		enemy: []EnemyI,
		npc: []NpcI,
		object: []ObjectI
	}
}

Tile :: struct {
	name: cstring,
	type: TileType,
	texture: rl.Texture2D
}

preload_chunk :: proc(c: ^Chunk) {
	append(&unloaded_chunks[c.realm], c^)
}

destroy_chunk :: proc(c: ^Chunk) {
	delete(c.realm)
	delete(c.entities.enemy)
}

destroy_all_chunks :: proc() {
	for realm in unloaded_chunks {
		for &c in unloaded_chunks[realm] do destroy_chunk(&c)
		delete(unloaded_chunks[realm])
	}
}
