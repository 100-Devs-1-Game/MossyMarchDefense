class_name ExtraButton extends Button

const UI_CONFIRM = preload("uid://c043ehrek1xp4")

func _ready() -> void:
	mouse_entered.connect(_play_hover_sound)
	gui_input.connect(_play_click_sound)

func _play_hover_sound() -> void:
	pass

func _play_click_sound(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left_click"):
		pass
