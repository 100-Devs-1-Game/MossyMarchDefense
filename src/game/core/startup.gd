extends Node

func _ready() -> void:
	print('Game Starting.')
	
	# Do cool startup stuff here.
	
	# Will open the main menu, then queue itself free.
	
	await get_tree().create_timer(0.5).timeout
	
	UI.open_new_layer(&"MAIN_MENU")
	self.queue_free()
