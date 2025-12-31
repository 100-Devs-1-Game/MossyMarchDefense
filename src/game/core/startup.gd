extends Node

@onready var startup_animations: AnimationPlayer = %StartupAnimations

func _ready() -> void:
	
	# Stamp Intro
	startup_animations.play(&"stamp")
	await startup_animations.animation_finished
	
	
	UI.open_new_layer(&"MAIN_MENU")
	self.queue_free()
