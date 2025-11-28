extends Node2D

@export var target = self.global_position
@export var speed = 200
@onready var dir = global_position.direction_to(target)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print (target)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += dir * speed * delta
