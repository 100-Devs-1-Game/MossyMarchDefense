class_name Level extends Node

@export_category("Level Settings")
@export var level_key : String = ""
@export var starting_acorns : int = 5
@export var worm_health : int = 30
@export_category("Level Waves")
@export var wave_structures : Array[WaveStructure] = []
@export_category("Level Visual & Audio")
@export var level_theme : Audio.Music
@export var rain_enabled : bool = true

# Level Progress Tracking
var current_acorns : int = 0
var current_wave : int = 0
var between_waves : bool = true
var done_spawning : bool = true
var current_enemies : Array[Enemy] = []
var enemies_alive_count: int = 0
var wave_spawn_complete: bool = false

# Core Node References
@onready var towers: Node2D = %Towers
@onready var acorns: Node2D = %Acorns
@onready var path_nodes: Node2D = %PathNodes
@onready var caterpillar_root: Node2D = %CaterpillarRoot
@onready var enemy_root: Node2D = %EnemyRoot
@onready var rain: AnimatedSprite2D = %rain
@onready var tower_markers: Node2D = %TowerMarkers
@onready var bullets: Node2D = %Bullets

# Important Nodes
var first_path_node : PathNode = null
var worm_spawn_node : PathNode = null
var final_path_node : PathNode = null
var node_array : Array[Node] = []

var current_caterpillar : Caterpillar = null

const WORM = preload("uid://oykmyp40ux3u")

# If ever worked on again, more sustainable references than here advised. -Phoenix
const ENEMY_01_BIRD = preload("uid://cxcrvo7kbfilv")
const ENEMY_02_SNAIL = preload("uid://j2l5116pp4ql")
const ENEMY_03_FROG = preload("uid://b8c6ry6bavun6")
const WAVE_START = preload("uid://tmp0nqcw3odb")

# Level States
var level_ready : bool = false
var exit_finished : bool = false
var level_succeeded : bool = false
var level_failed : bool = false

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
	SignalBus.start_wave_clicked.connect(_on_wave_start_button_pressed)
	SignalBus.pause_wave_clicked.connect(_on_pause_button_pressed)
	
	SignalBus.wave_started.connect(_on_wave_started)
	SignalBus.wave_ended.connect(_on_wave_ended)
	SignalBus.section_started.connect(_on_wave_section_started)
	# NOTE: section_ended is used for await functions. Doesn't need to be connected here. -Phoenix
	
	SignalBus.level_finished.connect(_on_level_finished)
	SignalBus.level_failed.connect(_on_level_failed)
	
	SignalBus.acorns_gained.connect(_on_acorns_gained)
	SignalBus.acorns_spent.connect(_on_acorns_spent)
	
	
	SignalBus.level_initialization_complete.connect(_on_initialization_complete)

func _call_level_music() -> void:
	Audio.play_level_song(level_theme)
	Audio.toggle_highpass_filter(true)


func _connect_path_nodes() -> void:
	node_array = path_nodes.get_children()
	
	# Failsafes/Validation
	if node_array.size() < 2: return
	
	for node in node_array:
		if node is not PathNode:
			return
	
	# Set node references.
	first_path_node = node_array[0]
	worm_spawn_node = node_array[2]
	var curr_node:PathNode = node_array[0]
	
	# Connect each node to the next one
	for i in range(node_array.size() - 1):
		var next_node:PathNode = node_array[i + 1]
		curr_node.next_path_node = next_node
		curr_node = next_node
	
	# Mark the last node as exit node
	curr_node.exit_node = true
	final_path_node = curr_node


func _on_acorns_gained(amount:int) -> void:
	current_acorns += amount

func _on_acorns_spent(amount:int) -> void:
	current_acorns -= amount


func _on_wave_start_button_pressed():
	SignalBus.set_current_wave.emit(current_wave)
	if between_waves: 
		between_waves = false
		Audio.toggle_highpass_filter(false)
		Audio.play_ui_sound(WAVE_START)
		SignalBus.wave_started.emit()

func _on_pause_button_pressed():
	var time_scale = Engine.time_scale
	if time_scale <= 0.0:
		Audio.toggle_highpass_filter(false)
		Engine.time_scale = 1.0
	else:
		Audio.toggle_highpass_filter(true)
		Engine.time_scale = 0.0


func add_tower(tower:BaseTower) -> void:
	towers.add_child(tower)


func exit_level() -> void:
	exit_finished = true
	SignalBus.level_exited_successfully.emit(self)
	print('level exited')
	self.queue_free()


func _on_wave_started() -> void:
	var target_structure = wave_structures.get(current_wave)
	_spawn_caterpillar(target_structure.worm_start_node, 5)
	
	done_spawning = false
	wave_spawn_complete = false
	enemies_alive_count = 0
	
	for section:WaveSection in target_structure.wave_sections:
		SignalBus.section_started.emit(section)
		await SignalBus.section_ended
		if level_failed:
			break
	
	if not level_failed:
		done_spawning = true
		wave_spawn_complete = true
		_check_wave_completion()


func _on_wave_section_started(wave_section:WaveSection) -> void:
	for enemy_type:ENUM.EnemyType in wave_section.enemies:
		_spawn_next_enemy(enemy_type)
		await get_tree().create_timer(wave_section.section_interval).timeout
		if level_failed:
			break
	
	if not level_failed:
		SignalBus.section_ended.emit()


func _on_wave_ended():
	Audio.toggle_highpass_filter(true)
	if current_caterpillar:
		current_caterpillar.queue_free()
	between_waves = true
	current_wave += 1
	
	if current_wave > wave_structures.size() - 1:
		SignalBus.level_finished.emit()

func _spawn_next_enemy(enemy_type:ENUM.EnemyType):
	var _spawned_enemy : Enemy = null
	match enemy_type:
		ENUM.EnemyType.Bird:
			_spawned_enemy = ENEMY_01_BIRD.instantiate()
		ENUM.EnemyType.Snail:
			_spawned_enemy = ENEMY_02_SNAIL.instantiate()
		ENUM.EnemyType.Frog:
			_spawned_enemy = ENEMY_03_FROG.instantiate()
	
	enemy_root.add_child(_spawned_enemy)
	_spawned_enemy.spawn_in(current_caterpillar, node_array)
	
	# Increment enemy count and connect signal
	enemies_alive_count += 1
	_spawned_enemy.killed.connect(_on_enemy_killed.bind(_spawned_enemy))


func _on_enemy_killed(body: Enemy) -> void:
	enemies_alive_count -= 1
	body.queue_free()
	
	# Check if wave should end
	_check_wave_completion()

func _check_wave_completion() -> void:
	if wave_spawn_complete and enemies_alive_count == 0:
		SignalBus.wave_ended.emit()


func _spawn_caterpillar(node_number:int, start_health:int) -> void:
	current_caterpillar = WORM.instantiate()
	caterpillar_root.add_child(current_caterpillar)
	current_caterpillar.setup(node_number, node_array, start_health)
	current_caterpillar.start_running()


func _grab_caterpillar_spawn_pos(node_number:int) -> Vector2:
	var _path_node : PathNode = path_nodes.get_child(node_number)
	return _path_node.global_position


func _on_level_finished():
	level_succeeded = true
	await get_tree().process_frame
	UI.open_new_layer(&"LEVEL_FINISHED")


func _on_level_failed() -> void:
	level_failed = true
	await get_tree().process_frame
	UI.open_new_layer(&"LEVEL_FINISHED")
