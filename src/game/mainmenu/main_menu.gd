extends Control

const LEVEL_1_SCENE := preload("res://game/scenes/levels/level_1.tscn")

@onready var level_1_button = $Control/Menu/Level1Button


func _ready():
	level_1_button.pressed.connect(on_level_1_pressed)
	
	
func on_level_1_pressed():
	get_tree().change_scene_to_packed(LEVEL_1_SCENE)
