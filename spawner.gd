extends Node2D

@onready var ne_marker = $"../NEMarker"
@onready var se_marker = $"../SEMarker"
@onready var nw_marker = $"../NWMarker"
@onready var sw_marker = $"../SWMarker"
@onready var test_map = $"../../test_map_michael"
var Enemy = preload("res://enemy.tscn")
var list_spawn_points

#func _ready():
	#list_spawn_points = [
		#ne_marker.global_positon,
		#se_marker.global_positon,
		#nw_marker.global_positon,
		#sw_marker.global_positon
	#]

func _on_spawn_timer_timeout() -> void:
	print("spawning")
	list_spawn_points = [
		ne_marker.position,
		se_marker.position,
		nw_marker.position,
		sw_marker.position
	]
	var e = Enemy.instantiate()
	var point = randi() % 4
	print("random point" + str(point))
	e.position = list_spawn_points[point]
	test_map.add_child(e)
