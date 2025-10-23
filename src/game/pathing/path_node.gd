extends Node2D

@export var next_path_node : Node2D
@export var exit_node : bool = false
@onready var area_2d = $Area2D

func _ready():
	area_2d.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body):
	if not body in get_tree().get_nodes_in_group("enemy"):
		return
	
	if exit_node:
		# TODO: Health and score
		body.queue_free()
		return
	
	body.movement_component.update_target_location(body.navigation_agent_2d, next_path_node.global_position)
