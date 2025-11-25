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
@export var player_health: Label

# DEBUG LIKELY (will be better later)
# Anything to do with these text labels is DEBUG, WILL BE IMRPOVED LATER
#I swapped em to export so we can move them around without having to rewrite🥚
@export var worms: Label
@export var player_money_label: Label
@export var wave_counter: Label
@export var worm_spawn_node: Node # This is just set to 2nd node for now for testing
@export var worm_path_node: Node # Again debug

#defines and sets health for the player so we can alter it here🥚
@export var starting_hp: int = 30
var current_hp: int = starting_hp

func _ready():
	debug_spawn_worms()
	
	wave_start_button.pressed.connect(on_wave_start_button_pressed)
	worms.text = "WORMS: " + str(player_worms)
	player_money_label.text = "$" + str(player_money)
	
	if first_path_node: #if first node available
		#connect to it's damage_taken signal, and call damage_player on recieve
		first_path_node.damage_taken.connect(damage_player)

func _process(_delta: float) -> void:
	_refresh_ui()

func _refresh_ui() -> void:
	if player_health:
		player_health.text = "HP:" + str(current_hp) + "/" + str(starting_hp)

func get_first_path_node(worm: bool):
	if worm:
		return worm_path_node
	return first_path_node

func remove_worms():
	player_worms -= 1
	
	worms.text = "WORMS: " + str(player_worms)
	
	if player_worms == 0:
		lose_game()
		
	adjust_enemies(-1)

func add_worms():
	player_worms += 1
	
	worms.text = "WORMS: " + str(player_worms)
	
	
func adjust_enemies(modifier : int):
	enemies_on_screen += modifier
	
	if enemies_on_screen == 0 and enemy_spawner.spawning_enemies == false:
		end_wave()

func start_wave():
	
	wave_counter.text = "WAVE " + str(current_wave)
	between_waves = false
	wave_start_button.disabled = true #i swapped it to disable
	wave_start_button.text = "Wave in progress" #mb if it interferes with things🥚
	enemy_spawner.start_wave()

func end_wave():
	current_wave += 1
	
	if current_wave > NUM_WAVES:
		win_game()
	else:
		between_waves = true
		wave_start_button.disabled = false
		wave_start_button.text = "Next Wave"

func pay_player(payout: int):
	player_money += payout
	player_money_label.text = "$" + str(player_money)

func damage_player(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0: #if hp is or below 0, gameover
		current_hp = 0
		lose_game()

# TODO: Obviously this aint the final functions for winning nor losing
func win_game():
	print("You Won!")

func lose_game():
	get_tree().quit()
	
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
