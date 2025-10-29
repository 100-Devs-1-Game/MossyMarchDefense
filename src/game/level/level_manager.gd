extends Node

const NUM_WAVES = 2

var enemy_queue
var current_wave := 1
var between_waves := true
var enemies_on_screen := 0

@export var player_worms : int
@export var first_path_node : Node2D
@export var enemy_spawner : Node
@export var player_money : int
@export var wave_start_button : Button

func _ready():
	wave_start_button.pressed.connect(on_wave_start_button_pressed)

func get_first_path_node():
	return first_path_node

func remove_worms():
	player_worms -= 1
	
	if player_worms == 0:
		lose_game()
		
	adjust_enemies(-1)

func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		end_wave()

func start_wave():
	between_waves = false
	wave_start_button.visible = false
	enemy_spawner.start_wave()

func end_wave():
	current_wave += 1
	
	if current_wave > NUM_WAVES:
		win_game()
	else:
		between_waves = true
		wave_start_button.visible = true

# TODO: Obviously this aint the final functions for winning nor losing
func win_game():
	print("You Won!")

func lose_game():
	get_tree().quit()

func on_wave_start_button_pressed():
	if between_waves:
		start_wave()
