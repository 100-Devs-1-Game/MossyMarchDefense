class_name RES_DATA
## Helper RES_DATA Class to grab resource values.
## Call any of the functions to get what you need in the project. -Phoenix

const res_paths : Dictionary = { 
	"plant_pot" : "res://resources/tower_data/plant_pot_tower.tres",
	"watering_can" : "res://resources/tower_data/watering_can_tower.tres"
}

static func get_tower_data_duplicate_by_key(tower_key:String) -> TowerData:
	if not _is_valid_key(tower_key):
		printerr("Invalid tower key: " + tower_key)
		return null
	
	var LOADED_RES : Resource = load(res_paths[tower_key])
	if not LOADED_RES is TowerData:
		printerr("Loaded resource is not TowerData for key: " + tower_key)
		return null
	
	return LOADED_RES.duplicate()


static func get_tower_data_duplicate_from_enum(tower_type:GlobalEnums.TowerType) -> TowerData:
	var key : String = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Could not get key from TowerType: " + str(tower_type))
		return null
	
	return get_tower_data_duplicate_by_key(key)


static func get_tower_type(tower_key:String) -> GlobalEnums.TowerType:
	if not _is_valid_key(tower_key):
		printerr("Returning default enum, plant pot. Invalid tower key: " + tower_key)
		return GlobalEnums.TowerType.PlantPot
	
	var resource = load(res_paths[tower_key])
	if not resource is TowerData:
		printerr("Returning default enum, plant pot. Loaded resource is not TowerData for key: " + tower_key)
		return GlobalEnums.TowerType.PlantPot
	
	return resource.tower_type


static func get_detection_radius(tower_key:String) -> float:
	if not _is_valid_key(tower_key):
		printerr("Invalid tower key: " + tower_key)
		return 0.0
	
	var resource = load(res_paths[tower_key])
	if not resource is TowerData:
		printerr("Loaded resource is not TowerData for key: " + tower_key)
		return 0.0
	
	return resource.detection_radius


static func get_sprite(tower_key:String) -> Texture2D:
	if not _is_valid_key(tower_key):
		printerr("Invalid tower key: " + tower_key)
		return null
	
	var resource = load(res_paths[tower_key])
	if not resource is TowerData:
		printerr("Loaded resource is not TowerData for key: " + tower_key)
		return null
	
	return resource.sprite


static func get_sprite_frames(tower_key:String) -> SpriteFrames:
	if not _is_valid_key(tower_key):
		printerr("Invalid tower key: " + tower_key)
		return null
	
	var resource = load(res_paths[tower_key])
	if not resource is TowerData:
		printerr("Loaded resource is not TowerData for key: " + tower_key)
		return null
	
	return resource.sprite_frames


static func get_cost(tower_key:String) -> int:
	if not _is_valid_key(tower_key):
		printerr("Invalid tower key: " + tower_key)
		return 0
	
	var resource = load(res_paths[tower_key])
	if not resource is TowerData:
		printerr("Loaded resource is not TowerData for key: " + tower_key)
		return 0
	
	return resource.cost


static func get_tower_type_from_enum(tower_type:GlobalEnums.TowerType) -> GlobalEnums.TowerType:
	var key = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Returning default enum, plant pot. Could not get key from TowerType: " + str(tower_type))
		return GlobalEnums.TowerType.PlantPot
	
	return get_tower_type(key)


static func get_detection_radius_from_enum(tower_type:GlobalEnums.TowerType) -> float:
	var key = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Could not get key from TowerType: " + str(tower_type))
		return 0.0
	
	return get_detection_radius(key)


static func get_sprite_from_enum(tower_type:GlobalEnums.TowerType) -> Texture2D:
	var key = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Could not get key from TowerType: " + str(tower_type))
		return null
	
	return get_sprite(key)


static func get_sprite_frames_from_enum(tower_type:GlobalEnums.TowerType) -> SpriteFrames:
	var key = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Could not get key from TowerType: " + str(tower_type))
		return null
	
	return get_sprite_frames(key)


static func get_cost_from_enum(tower_type:GlobalEnums.TowerType) -> int:
	var key = _get_key_from_type(tower_type)
	if key.is_empty():
		printerr("Could not get key from TowerType: " + str(tower_type))
		return 0
	
	return get_cost(key)


## Ignore this, private helper function. Do not use this. - Phoenix
static func _get_key_from_type(tower_type:GlobalEnums.TowerType) -> String:
	match tower_type:
		GlobalEnums.TowerType.PlantPot:
			return "plant_pot"
		GlobalEnums.TowerType.WateringCan:
			return "watering_can"
		_:
			printerr("Not a valid TowerType: " + str(tower_type))
			return ""


## Private helper to validate keys
static func _is_valid_key(tower_key:String) -> bool:
	if not res_paths.has(tower_key):
		printerr("Key not found in res_paths: " + tower_key)
		return false
	return true
