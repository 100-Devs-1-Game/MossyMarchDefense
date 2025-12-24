extends Node

const NUM_WAVES = 2
const WORM_SCENE = preload("res://game/enemies/worm.tscn")
const STARTUP_SCENE = preload("res://game/core/startup.tscn")

var enemy_queue
var current_wave := 1
var between_waves := true
var enemies_on_screen := 0
var ui_layer: UILayer

@export var first_path_node : Node2D
@export var enemy_spawner : Node
@export var player_health: Label
@export var level_theme : GlobalEnums.MusicTitle

# DEBUG LIKELY (will be better later)
# Anything to do with these text labels is DEBUG, WILL BE IMRPOVED LATER
#I swapped em to export so we can move them around without having to rewrite🥚
@export var worm_spawn_node: Node # This is just set to 2nd node for now for testing
@export var worm_path_node: Node # Again debug


func _ready():
	# debug_spawn_worms()
	
	_connect_signals()
	

func _connect_signals():
	SignalBus.start_wave_clicked.connect(on_wave_start_button_pressed)
	SignalBus.pause_wave_clicked.connect(on_pause_button_pressed)
	SignalBus.retry_level.connect(on_retry_level)

func _process(_delta: float) -> void:
	_refresh_ui()

func _refresh_ui() -> void:
	
	pass

func get_first_path_node(worm: bool):
	if worm:
		return worm_path_node
	return first_path_node

func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		end_wave()

func start_wave():
	
	var worm_group = get_tree().get_first_node_in_group("worm_group")
	var worm_instance = WORM_SCENE.instantiate()
	worm_group.add_child(worm_instance)
	worm_instance.global_position = worm_spawn_node.global_position
	
	between_waves = false
	enemy_spawner.start_wave()

func end_wave():
	between_waves = true
	
	current_wave += 1
	
	cleanup_enemies()
	
	if current_wave > NUM_WAVES:
		win_game()
	else:
		between_waves = true

func cleanup_enemies():
	var enemy_group = get_tree().get_first_node_in_group("enemies_group")
	
	for n in enemy_group.get_children():
		n.queue_free()

# TODO: Obviously this aint the final functions for winning nor losing
func win_game():
	get_tree().change_scene_to_packed(STARTUP_SCENE)

func lose_game():
	# TODO: Fade to black
	SignalBus.close_game_hud.emit()
	UI.open_new_layer(&"GAME_OVER")
	
func debug_spawn_worms():
	#only show in debug scene, when this is set
	if worm_spawn_node == null:
		return

	var worm = enemy_spawner.enemy
	var worm_instance = worm.instantiate()
	var enemies_group = get_tree().get_first_node_in_group("enemies_group")
	enemies_group.add_child(worm_instance)
	worm_instance.load_enemy_stats(enemy_spawner.enemy_dictionary["worm"])
	worm_instance.global_position = worm_spawn_node.global_position

func on_wave_start_button_pressed():
	if between_waves: 
		
		start_wave()
		
func on_pause_button_pressed():
	var time_scale = Engine.time_scale
	if time_scale <= 0:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 0

func on_retry_level():
	current_wave = 1
	
	get_tree().reload_current_scene()
