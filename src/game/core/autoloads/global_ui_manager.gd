extends CanvasLayer


const LAYER_PATHS : Dictionary = {
	"MAIN_MENU" : "res://game/ui/ui_list/ui_main_menu.tscn",
	"GAME_HUD" : "res://game/ui/ui_list/ui_game_hud.tscn",
	"LEVEL_FINISHED" : "res://game/ui/ui_list/ui_level_finished.tscn",
	"DEBUG_INFO" : "",
}

var top_layer : UILayer = null
@onready var ui_root: Control = %UIRoot

func _ready() -> void:
	layer = 69
	_connect_signals()


func _connect_signals() -> void:
	pass


func open_new_layer(path_key:String) -> void:
	# Check if it exists - if not return + printerr.
	if LAYER_PATHS.has(path_key) == false:
		printerr(path_key + " not found in LAYER_PATHS.")
		return
	
	# Prevents duplicate layers opening.
	if is_layer_open(path_key):
		return
	
	var LOADED_UI:PackedScene = load(LAYER_PATHS[path_key])
	var new_layer:UILayer = LOADED_UI.instantiate()
	ui_root.add_child(new_layer)
	new_layer.name = path_key
	new_layer.close_layer.connect(_close_layer)
	
	_update_top_layer()

## Use close_layer.emit(self) - however it's needed for the layer. You decide! :D
func _close_layer(closing_layer:UILayer) -> void:
	closing_layer.queue_free()
	
	_update_top_layer()


func _update_top_layer() -> void:
	if ui_root.get_children().is_empty():
		top_layer = null
		return
	
	for open_layer:UILayer in ui_root.get_children():
		top_layer = ui_root.get_children().back()


## Useful to prevent duplicate layers being open.
## Used internally here for opening new layer, but can be used elsewhere for whatever reason you need.
func is_layer_open(layer_name:String) -> bool:
	for open_layer:UILayer in ui_root.get_children():
		if open_layer.name == layer_name:
			return true
	
	return false
