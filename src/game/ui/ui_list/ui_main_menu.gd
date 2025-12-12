extends UILayer

@onready var menu_anim: AnimationPlayer = %MenuAnimations

const LEVEL_1 = preload("uid://du7map0fgin22")

func _ready():
	menu_anim.play(&"main_menu_fade_in")


func on_level_1_pressed():
	get_tree().change_scene_to_packed(LEVEL_1)
	
	# Called by ANY UI Layer at any time, to close itself.
	close_layer.emit(self)
