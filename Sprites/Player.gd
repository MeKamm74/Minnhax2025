extends CharacterBody2D

@export var SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var jump_height: float = 100
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var initial_float_charge: int = 500

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1 
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

@onready var broom_jump_velocity: float = jump_velocity * 2 
@onready var broom_jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var broom_fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

@onready var float_charge = initial_float_charge

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += fetch_gravity() * delta
	else:
		float_charge = initial_float_charge

	# Handle Broom Jump.
	#if Input.is_action_just_pressed("broom_jump"):
		#velocity.y = broom_jump_velocity 
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $CoyoteJumpTimer.time_left > 0.0):
		velocity.y = jump_velocity
		
	if Input.is_action_pressed("float") and not is_on_floor() and float_charge > 0:
		velocity.y = 0
		float_charge -= 1


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if is_on_floor():
		$AnimatedSprite2D.animation = "run"
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "jump down"
	else:
		$AnimatedSprite2D.animation = "jump up"
	#$AnimatedSprite2D.flip_v = false
	$AnimatedSprite2D.flip_h = velocity.x < 0

	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		$CoyoteJumpTimer.start()

func fetch_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity
