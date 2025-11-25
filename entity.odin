package rune

import "core:fmt"
import rl "vendor:raylib"

Location :: struct {
	tile: [2]int,
	coords: rl.Vector2
}

Enemy :: struct {
	name: cstring,
}

Npc :: struct {
	name: cstring,
}

Object :: struct {
	name: cstring,
}

EnemyI :: struct {
	name: cstring,
	location: Location
}

NpcI :: struct {
	name: cstring,
	location: Location
}

ObjectI :: struct {
	name: cstring,
	location: Location
}
