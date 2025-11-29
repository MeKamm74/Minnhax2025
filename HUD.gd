extends MarginContainer

@onready var label: Label = $Label

var enemies = 0
var towers = 3 #should use max_towers from map.gd but that's harder

func _ready():
	Globals.enemyKilled.connect(_on_enemy_killed)
	Globals.remaining_towers.connect(_on_towers_updated)

func _on_enemy_killed():
	enemies += 1
	update_label()

func _on_towers_updated(_towers: int):
	towers = _towers
	update_label()

func update_label():
	label.text = "Defeated Enemies: " + str(enemies) + "\nPlaceable Towers: " + str(towers)
