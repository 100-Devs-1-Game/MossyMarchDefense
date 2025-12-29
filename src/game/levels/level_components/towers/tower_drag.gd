extends Sprite2D

signal on_dragged

@export var tower_type : ENUM.TowerType

var is_dragging = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				is_dragging = true
				#var mouse_offset = get_global_mouse_position() - global_position
				on_dragged.emit(tower_type)
		else:
			is_dragging = false
