extends Node2D

@export var _moveSpeed := 0.8

@onready var animate: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var HP = 3

enum State {
	IDLE, 
	FOLLOW
}

enum Direction {
	IDLE, 
	UP, 
	DOWN, 
	LEFT, 
	RIGHT
}

var _path := PackedVector2Array()

func set_path_to_base(new_path: PackedVector2Array) -> void:
	_path = new_path
	move_along_path()

func move_along_path() -> void:
	for i in range(1, _path.size()):
		assign_animation(_path[i])
		var tween = create_tween()
		tween.tween_property(self, "position", _path[i], _moveSpeed)
		await tween.finished
	assign_animation(position)
	
func assign_animation(target_pos: Vector2) -> void: 
	var current_pos = position
	
	var direction_x = target_pos.x - current_pos.x
	var direction_y = target_pos.y - current_pos.y
	
	if direction_x > 0:
		animate.play("move_left")
		animate.flip_h = true
	elif direction_x < 0:
		animate.play("move_left")
		animate.flip_h = false
	elif direction_y > 0:
		animate.play("move_down")
	elif direction_y < 0:
		animate.play("move_up")
	else:
		animate.play("idle")

func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	print("enemy body detected!")
	if(area.is_in_group("bullets")):
		HP -= 1
		area.queue_free()
		if(HP <= 0):
			queue_free()
