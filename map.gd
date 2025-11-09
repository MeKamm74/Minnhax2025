
extends Node2D

@onready var base_layer: TileMapLayer = $base_layer
@onready var terrain_layer: TileMapLayer = $terrain_layer

var _astar = AStarGrid2D.new()
var tile_size = Vector2i(24, 24)

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
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			var cell_data = terrain_layer.get_cell_tile_data(pos)
			if cell_data && cell_data.get_custom_data("Obstacle"):
				_astar.set_point_solid(pos)
				print("Point: " + str(pos.x) + ", " + str(pos.y) + " is a mountain base")


func get_path_map(start_coords, end_coords):
	var start_point = base_layer.local_to_map(start_coords)
	var end_point = base_layer.local_to_map(end_coords)
	# Example of how to use the path
	var path = _astar.get_point_path(start_point, end_point)
	return path

func round_local_position(local_position):
	return base_layer.map_to_local(base_layer.local_to_map(local_position))


func is_point_walkable(local_position):
	var map_position = base_layer.local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false
