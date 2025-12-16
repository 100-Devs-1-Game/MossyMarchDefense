extends UILayer

@onready var menu_anim: AnimationPlayer = %MenuAnimations
@onready var level_container: GridContainer = %LevelContainer

# TODO: Maybe make the preloads consistent
const LEVEL_1 = preload("uid://du7map0fgin22")
const LEVEL_2 = preload("res://game/levels/level_list/level_02.tscn")
const LEVEL_3 = preload("res://game/levels/level_list/level_03.tscn")

func _ready():
	menu_anim.play(&"main_menu_fade_in")

func load_level(level):
	_disable_buttons()
	get_tree().change_scene_to_packed(level)
	
	UI.open_new_layer(&"GAME_HUD")
	
	# More temporary code, to get around other stuff.
	await get_tree().create_timer(0.5).timeout
	Instance.set_current_level(get_tree().current_scene)
	
	
	# Called by ANY UI Layer at any time, to close itself.
	close_layer.emit(self)

func on_level_1_pressed():
	load_level(LEVEL_1)
	
func on_level_2_button_pressed():
	load_level(LEVEL_2)

func on_level_3_button_pressed():
	load_level(LEVEL_3)

func _disable_buttons() -> void:
	for button in level_container.get_children():
		button.disabled = true
