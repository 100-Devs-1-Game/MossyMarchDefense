extends UILayer

@onready var background: TextureRect = %Background
@onready var buttons: HBoxContainer = %Buttons

const GAME_OVER = preload("uid://xo4y7l347mwu")
const LEVEL_COMPLETE = preload("uid://kksiagft4hqq")

func _ready():
	Audio.toggle_highpass_filter(true)
	if Instance.current_level.level_failed:
		background.texture = GAME_OVER
	elif Instance.current_level.level_succeeded:
		background.texture = LEVEL_COMPLETE


func on_main_menu_pressed():
	
	_disable_buttons()
	
	Instance.return_to_main_menu()
	
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
	for button in buttons.get_children():
		button.disabled = true
