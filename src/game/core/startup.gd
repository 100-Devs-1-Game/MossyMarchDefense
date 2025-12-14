extends Node

func _ready() -> void:
	print('Game Starting.')
	
	# Do cool startup stuff here.
	
	# Will open the main menu, then queue itself free.
	
	UI.open_new_layer(&"MAIN_MENU")
	self.queue_free()
