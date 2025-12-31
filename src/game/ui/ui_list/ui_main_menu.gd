extends UILayer

@onready var menu_anim: AnimationPlayer = %MenuAnimations
@onready var level_container: HBoxContainer = %LevelContainer

func _ready():
	Audio.play_new_song("main_menu")
	menu_anim.play(&"main_menu_fade_in")
	await menu_anim.animation_finished
	_toggle_buttons_disabled(false)
	

func _toggle_buttons_disabled(state:bool) -> void:
	for button in level_container.get_children():
		button.disabled = state


func _on_level_1_button_pressed() -> void:
	_toggle_buttons_disabled(true)
	Instance.change_to_level("level_01")
	close_layer.emit(self)


func _on_level_2_button_pressed() -> void:
	_toggle_buttons_disabled(true)
	Instance.change_to_level("level_02")
	close_layer.emit(self)


func _on_level_3_button_pressed() -> void:
	_toggle_buttons_disabled(true)
	Instance.change_to_level("level_03")
	close_layer.emit(self)
