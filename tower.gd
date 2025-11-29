extends Node2D

@onready var enemies = []

var Bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_closest_enemy():
	var closestEnemy = enemies[0]
	var closestDistance = enemies[0].global_position.distance_squared_to(self.global_position)
	for enemy in enemies:
		var distance = enemy.global_position.distance_squared_to(self.global_position)
		if distance < closestDistance:
			closestEnemy = enemy
			closestDistance = distance
	
	return closestEnemy

func get_list_of_enemies():
	enemies = get_tree().get_nodes_in_group("enemies")

func shoot(enemy):
	var target = enemy.global_position
	#print(target)
	var bullet = Bullet.instantiate()
	bullet.target = target
	add_child(bullet)
	bullet.global_position = global_position

func _on_shoot_timer_timeout() -> void:
	get_list_of_enemies()
	var enemy = get_closest_enemy()
	shoot(enemy)
