extends UILayer

@onready var menu_anim: AnimationPlayer = %MenuAnimations
@onready var level_container: GridContainer = %LevelContainer

const LEVEL_1 = preload("uid://du7map0fgin22")

func _ready():
	menu_anim.play(&"main_menu_fade_in")


func on_level_1_pressed():
	_disable_buttons()
	get_tree().change_scene_to_packed(LEVEL_1)
	
	UI.open_new_layer(&"GAME_HUD")
	
	# More temporary code, to get around other stuff.
	await get_tree().create_timer(0.5).timeout
	Instance.set_current_level(get_tree().current_scene)
	
	
	# Called by ANY UI Layer at any time, to close itself.
	close_layer.emit(self)

func _disable_buttons() -> void:
	for button in level_container.get_children():
		button.disabled = true
