extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gameOver.connect(on_game_over)


func on_game_over():
	get_tree().paused = true
	show()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
