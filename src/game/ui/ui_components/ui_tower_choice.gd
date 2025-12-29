class_name UITowerChoice extends TextureRect

@export var tower_type:ENUM.TowerType
@export var tower_icon:Texture2D = null


var disabled : bool = false

func set_disabled_state(state:bool) -> void:
	disabled = state

func is_disabled() -> bool:
	return disabled
