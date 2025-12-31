extends Node

const LEVEL_PATHS : Dictionary = {
	"level_01" : "res://game/levels/level_list/level_01.tscn",
	"level_02" : "res://game/levels/level_list/level_02.tscn",
	"level_03" : "res://game/levels/level_list/level_03.tscn"
}

var current_level:Level = null


func change_to_level(level_key:String) -> void:
	if LEVEL_PATHS.has(level_key) == false:
		return
	
	if current_level != null:
		current_level.exit_level()
		if current_level.exit_finished == false:
			await SignalBus.level_exited_successfully
	
	var LOADED_LEVEL : PackedScene = load(LEVEL_PATHS[level_key])
	var new_level : Level = LOADED_LEVEL.instantiate()
	self.add_child(new_level)
	current_level = new_level
	new_level.initialize_level()

func return_to_main_menu() -> void:
	if Instance.current_level != null:
		Instance.current_level.exit_level()
	UI.open_new_layer(&"MAIN_MENU")


func reset_current_level() -> void:
	var current_level_key:String = current_level.level_key
	current_level.exit_level()
	if current_level.exit_finished == false:
		await SignalBus.level_exited_successfully
	
	
	await get_tree().create_timer(1.0).timeout
	
	
	var LOADED_LEVEL : PackedScene = load(LEVEL_PATHS[current_level_key])
	var new_level : Level = LOADED_LEVEL.instantiate()
	self.add_child(new_level)
	current_level = new_level
	new_level.initialize_level()

func get_current_acorns() -> int:
	return current_level.current_acorns


func set_current_level(new_level:Level) -> void:
	current_level = new_level

func get_path_node(node_num:int) -> PathNode:
	return current_level.path_nodes.get_child(node_num)
