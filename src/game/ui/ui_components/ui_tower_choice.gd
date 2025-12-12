class_name UITowerChoice extends TextureRect

@export var tower_type:GlobalEnums.TowerType
@export var tower_icon:Texture2D = null

func _get_drag_data(_at_position: Vector2) -> Variant:
	
	var drag_preview = TextureRect.new()
	drag_preview.texture = tower_icon
	drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	drag_preview.size = Vector2(150, 150)
	set_drag_preview(drag_preview)
	
	return tower_type
