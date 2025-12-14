class_name UITowerChoice extends Panel

@export var tower_type:GlobalEnums.TowerType
@export var tower_icon:Texture2D = null

@export var scaled_texture:TextureRect = null

var disabled : bool = false

func set_disabled_state(state:bool) -> void:
	disabled = state

func is_disabled() -> bool:
	return disabled
