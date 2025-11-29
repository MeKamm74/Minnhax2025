
extends Node2D

@onready var base_layer: TileMapLayer = $base_layer
@onready var terrain_layer: TileMapLayer = $terrain_layer
@onready var building_layer: TileMapLayer = $building_layer

@export var enemy_scene: PackedScene

var _astar = AStarGrid2D.new()
var tile_size = Vector2i(24, 24)
var base_coords: Vector2i
var spawner_coords: Array[Vector2i]

func _ready():
	# Region should match the size of the playable area plus one (in tiles).
	# Above is from a godot tutorial but the I am not sure why the plus one, testing w/o that currently 
	var map_width = (base_layer.get_used_rect().size.x)
	var map_height = (base_layer.get_used_rect().size.y)
	
	# get_used_rect always returns x,y of the top left corner and the size in w/h
	# then all other methods use global coords, so we can use top_left_corner + 0 thru width, etc to get populated coordinates
	var map_data = base_layer.get_used_rect()
	
	_astar.region = Rect2i(map_data.position.x, map_data.position.y, map_width, map_height)
	_astar.cell_size = tile_size
	_astar.offset = tile_size * 0.5
	# Manhattan Heuristic is for 4-directional grid movement, without diagonals, etc
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	
	# set obstacles as solid from the TERRAIN LAYER
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			var cell_data = terrain_layer.get_cell_tile_data(pos)
			if cell_data && cell_data.get_custom_data("Obstacle"):
				_astar.set_point_solid(pos)
				
	# check which tiles are buildings from the BUILDING LAYER
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			var cell_data = building_layer.get_cell_tile_data(pos)
			if cell_data && cell_data.get_custom_data("Base"):
				# Assumes we will only have one base
				base_coords = pos
			if cell_data && cell_data.get_custom_data("City"):
				#_astar.set_point_solid(pos)
				spawner_coords.append(pos)
				
	spawn_enemy()

func get_path_map(start_coords, end_coords):
	var path = _astar.get_point_path(start_coords, end_coords)
	return path

func get_base_coords():
	return base_coords

func get_enemy_path(current_pos):
	var _start_pos = terrain_layer.local_to_map(current_pos)
	var path = get_path_map(_start_pos, base_coords)
	return path.duplicate()

func spawn_enemy() -> void: 
	var new_enemy = enemy_scene.instantiate()
	if(spawner_coords.size() > 0):
		#enemy's ready function is called after add_child
		var spawner_pos = building_layer.map_to_local(spawner_coords[0])
		add_child(new_enemy)
		new_enemy.add_to_group("enemies")
		new_enemy.global_position = spawner_pos
		new_enemy.set_path_to_base(get_enemy_path(spawner_pos))

func round_local_position(local_position):
	return base_layer.map_to_local(base_layer.local_to_map(local_position))

func is_point_walkable(local_position):
	var map_position = base_layer.local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false
