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

# DEBUG LIKELY (will be better later)
# Anything to do with these text labels is DEBUG, WILL BE IMRPOVED LATER
@onready var worms = $"../Worms"
@onready var player_money_label = $"../PlayerMoney"
@onready var wave_counter = $"../WaveCounter"


func _ready():
	wave_start_button.pressed.connect(on_wave_start_button_pressed)
	
	worms.text = "WORMS: " + str(player_worms)
	player_money_label.text = "$" + str(player_money)

func get_first_path_node():
	return first_path_node

func remove_worms():
	player_worms -= 1
	
	worms.text = "WORMS: " + str(player_worms)
	
	if player_worms == 0:
		lose_game()
		
	adjust_enemies(-1)

func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		end_wave()

func start_wave():
	wave_counter.text = "WAVE " + str(current_wave)
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

func pay_player(payout: int):
	player_money += payout
	player_money_label.text = "$" + str(player_money)

# TODO: Obviously this aint the final functions for winning nor losing
func win_game():
	print("You Won!")

func lose_game():
	get_tree().quit()

func on_wave_start_button_pressed():
	if between_waves:
		start_wave()
