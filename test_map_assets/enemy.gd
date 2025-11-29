extends Node2D

@export var _moveSpeed := 0.8

@onready var animate: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

@onready var health_bar: ProgressBar = $ProgressBar

var max_HP = 5
var HP = 5

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

func _ready() -> void:
	health_bar.max_value = max_HP
	health_bar.min_value = 0
	health_bar.value = max_HP
	$Area2D.add_to_group("enemyArea")

func _physics_process(_delta: float) -> void:
	health_bar.value = HP

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
		animate.play("move_right")
		animate.flip_h = false
		#animate.rotate(270)
	elif direction_x < 0:
		animate.play("move_right")
		animate.flip_h = true
		#animate.rotate(90)
	elif direction_y > 0:
		animate.play("move_down")
		animate.flip_v = false
	elif direction_y < 0:
		animate.play("move_down")
		animate.flip_v = true
		#animate.rotate(180)
	else:
		animate.play("idle")

func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if(area.is_in_group("bullets")):
		HP -= 1
		area.queue_free()
		if(HP <= 0):
			queue_free()
			Globals.enemyKilled.emit()
