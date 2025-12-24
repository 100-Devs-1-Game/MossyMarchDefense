class_name TowerMarker extends Area2D

@onready var placement_preview: Sprite2D = %PlacementPreview
@onready var preview_anim: AnimationPlayer = %PreviewAnim
@onready var range_display: ColorRect = %AimRadius

const DEBUG_TOWER = preload("uid://ht2s7wyyb24a")

var occupied : bool = false

func _on_mouse_entered() -> void:
	SignalBus.tower_placement_hovered.emit(self)

func _on_mouse_exited() -> void:
	SignalBus.tower_placement_unhovered.emit(self)

func toggle_placement_preview(ui_tower:UITowerChoice, state:bool) -> void:
	if state == true:
		placement_preview.texture = ui_tower.tower_icon
		var _current_range : float = RES_DATA.get_detection_radius_from_enum(ui_tower.tower_type) * 2
		range_display.size = Vector2(
			_current_range,
			_current_range)
		
		range_display.pivot_offset = range_display.size / 2
		range_display.position = -range_display.size / 2
		
		range_display.visible = true
		
		preview_anim.play("preview_pulse")
	else:
		preview_anim.stop()
		placement_preview.texture = null
		range_display.visible = false

func tower_placed(tower_type:GlobalEnums.TowerType) -> void:
	var new_tower:Node2D = DEBUG_TOWER.instantiate()
	new_tower.tower_data = RES_DATA.get_tower_data_duplicate_from_enum(tower_type)
	
	## Bootleg lines of code to keep existing level structure working. When we set up a parent class.
	## May space king have mercy on our souls for this. Need to finish the parent level class ASAP.
	## -Phoenix
	
	Instance.current_level.add_tower(new_tower)
	new_tower.global_position = Vector2(
		self.global_position.x,
		self.global_position.y + _get_y_adjust(tower_type))
	
	SignalBus.acorns_spent.emit(RES_DATA.get_cost_from_enum(tower_type))
	toggle_placement_preview(null, false)
	occupied = true
	input_pickable = false


## Temporary func to adjust the vertical pos, since the things are diff size. xD -Phoenix
func _get_y_adjust(tower_type:GlobalEnums.TowerType) -> float:
	var y_adjust:float = -50
	
	match tower_type:
		GlobalEnums.TowerType.PlantPot:
			y_adjust = -50
		GlobalEnums.TowerType.WateringCan:
			y_adjust = -25
	
	return y_adjust
