class_name Level extends Node

const WORM_SCENE = preload("res://game/enemies/worm.tscn")
const STARTUP_SCENE = preload("res://game/core/startup.tscn")

@export_category("Level Settings")
@export var starting_acorns : int = 5
@export var worm_health : int = 30
@export_category("Level Waves")
@export var waves : Array[WaveData] = []
@export_category("Level Visual & Audio")
@export var level_theme : Audio.Music
@export var rain_enabled : bool = true

var current_acorns : int = 0
var enemy_queue
var current_wave : int = 1
var between_waves : bool = true
var enemies_on_screen : int = 0

# Core Node References
@onready var towers: Node2D = %Towers
@onready var path_nodes: Node2D = %PathNodes
@onready var enemy_spawner: EnemySpawner = %EnemySpawner
@onready var rain: AnimatedSprite2D = %rain

var first_path_node : PathNode = null
var worm_spawn_node : PathNode = null
var worm_path_node : PathNode = null

var level_ready : bool = false
var exit_finished : bool = false

func initialize_level() -> void:
	_call_level_music()
	_connect_path_nodes()
	_connect_signals()
	
	if rain_enabled:
		rain.visible = rain_enabled
	else : rain.queue_free()
	
	level_ready = true
	SignalBus.level_initialization_complete.emit()

func _on_initialization_complete() -> void:
	UI.open_new_layer(&"GAME_HUD")
	
	await get_tree().create_timer(0.1).timeout
	
	SignalBus.acorns_gained.emit(starting_acorns)


func _connect_signals():
	SignalBus.wave_ended.connect(_on_wave_ended)
	SignalBus.start_wave_clicked.connect(on_wave_start_button_pressed)
	SignalBus.pause_wave_clicked.connect(on_pause_button_pressed)

	SignalBus.acorns_gained.connect(_on_acorns_gained)
	SignalBus.acorns_spent.connect(_on_acorns_spent)
	
	SignalBus.level_initialization_complete.connect(_on_initialization_complete)

func _call_level_music() -> void:
	Audio.play_level_song(level_theme)
	Audio.toggle_highpass_filter(true)


func _connect_path_nodes() -> void:
	var children:Array = path_nodes.get_children()
	
	# Failsafes/Validation
	if children.size() < 2: return
	
	for node in children:
		if node is not PathNode:
			return
	
	# Set node references.
	first_path_node = children[0]
	worm_spawn_node = children[2]
	worm_path_node = worm_spawn_node
	enemy_spawner.spawner_path_node = first_path_node
	var curr_node:PathNode = children[0]
	
	# Connect each node to the next one
	for i in range(children.size() - 1):
		var next_node:PathNode = children[i + 1]
		curr_node.next_path_node = next_node
		curr_node = next_node
	
	# Mark the last node as exit node
	curr_node.exit_node = true


func get_first_path_node(worm: bool):
	if worm:
		return worm_path_node
	return first_path_node


func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		SignalBus.wave_ended.emit()


func start_wave():
	Audio.toggle_highpass_filter(false)
	var worm_group = get_tree().get_first_node_in_group("worm_group")
	var worm_instance = WORM_SCENE.instantiate()
	worm_group.add_child(worm_instance)
	worm_instance.global_position = worm_spawn_node.global_position
	
	between_waves = false
	enemy_spawner.start_wave()
	SignalBus.wave_started.emit()


func _on_wave_ended():
	Audio.toggle_highpass_filter(true)
	between_waves = true
	
	current_wave += 1
	
	cleanup_enemies()
	
	if current_wave > waves.size():
		win_game()
	else:
		between_waves = true

func _on_acorns_gained(amount:int) -> void:
	current_acorns += amount

func _on_acorns_spent(amount:int) -> void:
	current_acorns -= amount

func cleanup_enemies():
	var enemy_group = get_tree().get_first_node_in_group("enemies_group")
	
	for n in enemy_group.get_children():
		n.queue_free()


func win_game():
	Instance.return_to_main_menu()


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
		Audio.toggle_highpass_filter(false)
		start_wave()


func on_pause_button_pressed():
	var time_scale = Engine.time_scale
	if time_scale <= 0:
		Audio.toggle_highpass_filter(false)
		Engine.time_scale = 1
	else:
		Audio.toggle_highpass_filter(true)
		Engine.time_scale = 0


func add_tower(tower:BaseTower) -> void:
	towers.add_child(tower)


func exit_level() -> void:
	exit_finished = true
	SignalBus.level_exited_successfully.emit(self)
	self.queue_free()
