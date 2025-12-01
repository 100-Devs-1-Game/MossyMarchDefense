extends Node2D

@export var next_path_node : Node2D
@export var exit_node : bool = false
@onready var area_2d = $Area2D

signal damage_taken

func _ready():
	area_2d.body_entered.connect(on_body_entered)
	
	#if this is the exit node automatically sets itself as the next
	if exit_node:
		next_path_node = self
	
func on_body_entered(body):
	if not body in get_tree().get_nodes_in_group("enemy"):
		return
	
	if exit_node:
		var level_manager = get_tree().get_first_node_in_group("level_manager")
		if body.enemy_type == GlobalEnums.EnemyType.Worm:
			level_manager.add_worms()
		else:
			level_manager.remove_worms()
			damage_taken.emit() # TODO: Health and score #when damage dealt, emit a signal to let listeners know
			
		body.kill_enemy()
		return
	

	body.movement_component.update_target_location(body.navigation_agent_2d, next_path_node.global_position)
