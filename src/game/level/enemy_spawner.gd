extends Node

var enemy_queue : Array[String] # TODO: This will be handled via resources as well
var spawning_enemies := true


var enemy_dictionary = { # TODO: Convert this to resources
	"debug" : preload("res://game/enemies/debug_enemy.tscn")
}

@export var level_manager : Node
@export var base_spawn_time : float
@export var spawner_path_node : Node2D

@onready var spawn_timer = $SpawnTimer

func _ready():
	enemy_queue = ["debug", "debug", "debug"]
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
	spawn_timer.wait_time = base_spawn_time
	spawn_timer.start()
	
	
func spawn_next_enemy():
	var next_enemy = enemy_queue.pop_front()
	var next_enemy_instance = enemy_dictionary[next_enemy].instantiate()
	
	var enemies_group = get_tree().get_first_node_in_group("enemies_group")
	enemies_group.add_child(next_enemy_instance)
	next_enemy_instance.global_position = spawner_path_node.global_position
	
	level_manager.adjust_enemies(1)
	
	if enemy_queue.is_empty():
		spawning_enemies = false
	else:
		spawn_timer.start()
	
func on_spawn_timer_timeout():
	if spawning_enemies:
		spawn_next_enemy()
		
