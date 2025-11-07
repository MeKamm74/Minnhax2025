extends Node2D

enum State { IDLE, FOLLOW }

const MASS = 10.0
const ARRIVE_DISTANCE = 1.0

@export var speed: float = 100.0

var _state = State.IDLE
var _velocity = Vector2()

@onready var _tile_map = $"../map_holder"

var _click_position = Vector2()
var _path = PackedVector2Array()
var _next_point = Vector2()

func _ready():
	_change_state(State.IDLE)


func _process(_delta):
	if _state != State.FOLLOW:
		return
	var arrived_to_next_point = _move_to(_next_point)
	if arrived_to_next_point:
		if not _path.is_empty():
			_path.remove_at(0)
		if _path.is_empty():
			print("arrived")
			_change_state(State.IDLE)
			return
		_next_point = _path[0]


func _unhandled_input(event):
	_click_position = get_global_mouse_position()
	if _tile_map.is_point_walkable(_click_position):
		if event.is_action_pressed(&"teleport_to", false, true):
			_change_state(State.IDLE)
			global_position = _tile_map.round_local_position(_click_position)
		elif event.is_action_pressed(&"move_to"):
			_change_state(State.FOLLOW)


func _move_to(local_position):
	var desired_velocity = (local_position - position).normalized() * speed
	var steering = desired_velocity - _velocity
	_velocity += steering / MASS
	position += _velocity * get_process_delta_time()
	rotation = _velocity.angle()
	return position.distance_to(local_position) < ARRIVE_DISTANCE


func _change_state(new_state):
	if new_state == State.IDLE:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.stop()
		_path.clear()
	elif new_state == State.FOLLOW:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
		_path = _tile_map.get_path_map(position, _click_position)
		print(_path)
		if _path.size() < 1:
			_change_state(State.IDLE)
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		# _next_point = _path[1]
	_state = new_state
