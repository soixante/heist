extends Node

const N := 0x1
const E := 0x2
const S := 0x4
const W := 0x8

var moves = {N: Vector2(0, -1),
			S: Vector2(0, 1),
			E: Vector2(1, 0),
			W: Vector2(-1, 0)}

var walls = {Vector2(0, -1): N,
			Vector2(0, 1): S,
			Vector2(1, 0): E,
			Vector2(-1, 0): W}

var current_map = []
var path_maps = []

func _ready():
	init_paths()

func init_paths():
	path_maps = {Vector2(0,0): 0,
				Vector2(1,0): 1,
				Vector2(1,1): 2,
				Vector2(0,3): 3,
				Vector2(0,2): 4,
				Vector2(3,3): 5,
				Vector2(1,2): 6,
				Vector2(2,0): 7,
				Vector2(0,1): 8 ,
				Vector2(3,0): 9,
				Vector2(3,2): 10,
				Vector2(1,3): 11,
				Vector2(3,1): 12,
				Vector2(2,2): 13,
				Vector2(2,3): 14,
				Vector2(2,1): 15}

func can_pass(current_tile: Vector2, to: int) -> bool:
		var current_tile_mask = path_maps.get(current_tile)

		if current_tile_mask & to:
				return false

		return true
	

func valid_neighbour(current_tile: Vector2, neighbour_tile: Vector2, to: int) -> bool:
	var from: int
	match to:
		N:
			from = S
		E:
			from = W
		S:
			from = N
		W:
			from = E

	var first = false
	var second = false
	if can_pass(current_tile, to) && can_pass(neighbour_tile, from):
		first = true
	if !can_pass(current_tile, to) && !can_pass(neighbour_tile, from):
		second = true

	return first || second

