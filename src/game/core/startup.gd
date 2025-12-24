extends Node

@onready var startup_animations: AnimationPlayer = %StartupAnimations

func _ready() -> void:
	
	# Do cool startup stuff here.
	
	# Stamp Intro
	startup_animations.play(&"stamp")
	await startup_animations.animation_finished
	
	
	UI.open_new_layer(&"MAIN_MENU")
	self.queue_free()
