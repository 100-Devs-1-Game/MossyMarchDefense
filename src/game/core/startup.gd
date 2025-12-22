extends Node

@onready var startup_animations: AnimationPlayer = %StartupAnimations

func _ready() -> void:
	print('Game Starting.')
	
	# Do cool startup stuff here.
	startup_animations.play(&"stamp")
	# Will open the main menu, then queue itself free.
	
	await startup_animations.animation_finished
	
	UI.open_new_layer(&"MAIN_MENU")
	self.queue_free()
