extends Node2D

@onready var enemies = []

@onready var shoot_range: Area2D = $Area2D

var Bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_enemy_to_shoot():
	await get_tree().process_frame
	var objects = shoot_range.get_overlapping_bodies()
	var enemies_in_range = []
	var shortest_dist_to_base = 1000000
	var enemy_to_shoot = null
	for body in objects:
		if body.get_owner().is_in_group("enemies"):
			enemies_in_range.push_back(body)
	for enemy in enemies_in_range:
		var enemy_dist_to_base = enemy.global_position.distance_squared_to(self.global_position)
		if enemy_dist_to_base < shortest_dist_to_base:
			enemy_to_shoot = enemy
			shortest_dist_to_base = enemy_dist_to_base
	return enemy_to_shoot

func shoot(enemy):
	var target = enemy.global_position
	var bullet = Bullet.instantiate()
	bullet.target = target
	bullet.add_to_group("bullets")
	add_child(bullet)
	bullet.global_position = global_position

func _on_shoot_timer_timeout() -> void:
	var enemy = await get_enemy_to_shoot()
	if(enemy):
		shoot(enemy)
