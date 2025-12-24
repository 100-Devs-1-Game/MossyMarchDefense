extends UILayer

# TODO: I messed up and formatted the filename of the scene wrong oops!

@onready var button_container = $ButtonContainer
@onready var main_menu_button = %MainMenuButton
@onready var retry_level_button = $ButtonContainer/RetryLevelButton

const STARTUP_SCENE = preload("res://game/core/startup.tscn")

func _ready():
	main_menu_button.pressed.connect(on_main_menu_pressed)
	retry_level_button.pressed.connect(on_retry_level_pressed)
	AudioManager.play_sfx(GlobalEnums.SFXTitle.LevelFail)
	
func on_main_menu_pressed():
	
	_disable_buttons()
	
	# TODO: Make this go to Main Menu instead of Startup as this is a very hacky solution lmao
	get_tree().change_scene_to_packed(STARTUP_SCENE)
	
	# More temporary code, to get around other stuff.
	await get_tree().create_timer(3.0).timeout
	
	# Called by ANY UI Layer at any time, to close itself.
	close_layer.emit(self)

func on_retry_level_pressed():
	
	_disable_buttons()
	
	
	Instance.reset_current_level()
	UI.open_new_layer(&"GAME_HUD")
	
	SignalBus.retry_level.emit()
	
	await get_tree().create_timer(1.5).timeout
	
	# Called by ANY UI Layer at any time, to close itself.
	close_layer.emit(self)
	
	
func _disable_buttons() -> void:
	for button in button_container.get_children():
		button.disabled = true
