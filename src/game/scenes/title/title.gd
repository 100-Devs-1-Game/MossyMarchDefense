extends Control

@export var play_button: BaseButton
@export var quit_button: BaseButton

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	play_button.pressed.connect(func(): get_tree().change_scene_to_file("res://game/scenes/levels/level_1.tscn"))
	quit_button.pressed.connect(func(): get_tree().quit())
