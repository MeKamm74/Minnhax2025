extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("pause") and get_tree().paused == false):
		get_tree().paused = true
		show()
	elif (event.is_action_pressed("pause") and get_tree().paused == true):
		hide()
		get_tree().paused = false

#func _on_close_button_pressed():
	#hide()
	#get_tree().paused = false


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_quit_to_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
