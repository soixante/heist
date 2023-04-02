extends Node2D

@onready var Map: TileMap = $paths
@onready var Player: Boxer	= $boxer

@export var mapLayer: int = 0

var current_map = {}
var current_position: Vector2 = Vector2(0,0)
var current_tile: Vector2 = Vector2(0,0)

func _ready():
		randomize()
		current_map[current_position] = current_tile
		Map.set_cell(mapLayer, Vector2(0,0), 1, Vector2i(0,0))

func get_valid_tiles(tile_position):
	var possible_tiles = []
	for i in CoreConfig.path_maps.keys():
		var tile_value = CoreConfig.path_maps[i]
		var is_match = false
		for n in CoreConfig.walls.keys():
			var neighbour_tile:Vector2 = Map.get_cell_atlas_coords(self.mapLayer, tile_position + n)
			var neighbour_id = Map.get_cell_source_id(self.mapLayer, tile_position + n)
			if neighbour_id >= 0:
				if (CoreConfig.path_maps.get(neighbour_tile) & CoreConfig.walls[-n]) / CoreConfig.walls[-n] == (tile_value & CoreConfig.walls[n]) / CoreConfig.walls[n]:
					is_match = true
				else:
					is_match = false
					break
					
		if is_match and not i in possible_tiles:
			possible_tiles.append(i)
		
	return possible_tiles

func get_next_tile(tile_position:Vector2):
		var valid_tiles = get_valid_tiles(tile_position)

		if valid_tiles:
				return valid_tiles[randi() % valid_tiles.size()]

		return 

"""
		var chosen_tile: Vector2
		if valid_tiles:
				chosen_tile = valid_tiles[randi() % valid_tiles.size()]
"""


func generate_tile(direction: int) -> bool:
		var nextPosition = current_position + CoreConfig.moves[direction]
		var nextTile = get_next_tile(nextPosition)
				
		print (nextTile)
		if typeof(nextTile) != TYPE_NIL:
			Map.set_cell(mapLayer, nextPosition, 1, nextTile)
			current_position = nextPosition
			current_tile = nextTile
			current_map[current_position] = current_tile
			return true

		return false

func use_tile(direction: int) -> void:
		current_position += CoreConfig.moves[direction]
		current_tile = current_map.get(current_position)
		

func tile_exists(direction: int) -> bool:
		if current_map.has(current_position + CoreConfig.moves[direction]):
				return true

		return false

func reset_scene() -> void:
		current_map = {}
		Map.clear()
		current_position = Vector2(0,0)
		current_tile = Vector2(0,0)

func _input(event) -> void:
		if event.is_action_pressed("reset"):
				reset_scene()
				return
		
		if Player.moving:
				return

		var direction: int
		if event.is_action_pressed("move_left"):
				direction = CoreConfig.W
		if event.is_action_pressed("move_right"):
				direction = CoreConfig.E
		if event.is_action_pressed("move_up"):
				direction = CoreConfig.N
		if event.is_action_pressed("move_down"):
				direction = CoreConfig.S

		if direction:
				if can_move(direction):
						var tile_ok: bool = false
						if (!tile_exists(direction)):
								tile_ok = generate_tile(direction)
						else:
								use_tile(direction)
								tile_ok = true

						if tile_ok:
							Player.move(direction)

func can_move(direction: int) -> bool:
		return CoreConfig.can_pass(current_tile, direction)
				
