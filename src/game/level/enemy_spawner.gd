extends Node


var enemy_queue : Array[String] 
var spawning_enemies := false
var enemy = preload("res://game/enemies/debug_enemy.tscn")

var enemy_dictionary = {
	"snail": preload("res://resources/enemy_data/snail_enemy.tres"),
	"frog": preload("res://resources/enemy_data/frog_enemy.tres"),
	"bird": preload("res://resources/enemy_data/bird_enemy.tres"),
	"worm": preload("res://resources/enemy_data/worm_friend.tres")
}

@export var level_manager : Node
@export var base_spawn_time : float
@export var spawner_path_node : Node2D
@export var wave_set : Array[Wave]

@onready var spawn_timer = $SpawnTimer


func _ready():
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	
	
func spawn_next_enemy():
	var next_enemy = enemy_queue.pop_front()
	var next_enemy_instance = enemy.instantiate()
	var enemies_group = get_tree().get_first_node_in_group("enemies_group")
	enemies_group.add_child(next_enemy_instance)
	next_enemy_instance.load_enemy_stats(enemy_dictionary[next_enemy])
	next_enemy_instance.global_position = spawner_path_node.global_position
	
	level_manager.adjust_enemies(1)
	
	if enemy_queue.is_empty():
		spawning_enemies = false
	else:
		spawn_timer.start()

func start_wave():
	spawning_enemies = true
	var wave = wave_set[level_manager.current_wave - 1].duplicate()
	enemy_queue = wave.enemy_queue
	spawn_timer.wait_time = wave.enemy_spawn_timer
	spawn_timer.start()
	
func on_spawn_timer_timeout():
	if spawning_enemies:
		spawn_next_enemy()
