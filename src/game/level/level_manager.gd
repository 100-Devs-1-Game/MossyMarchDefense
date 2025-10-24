extends Node

var enemy_queue
var current_wave := 1
var between_waves := true
var enemies_on_screen := 0

@export var player_worms : int
@export var first_path_node : Node2D
@export var enemy_spawner : Node
@export var player_money : int

func get_first_path_node():
	return first_path_node

func remove_worms():
	player_worms -= 1
	
	if player_worms == 0:
		get_tree().quit()
		
	adjust_enemies(-1)

func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		print("we outta enemies")
