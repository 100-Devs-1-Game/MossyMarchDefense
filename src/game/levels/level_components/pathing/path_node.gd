class_name PathNode extends Node2D

var next_path_node : Node2D
var exit_node : bool = false
@onready var collision_area: Area2D = %CollisionArea

signal damage_taken

func _ready():
	collision_area.body_entered.connect(on_body_entered)
	
	#if this is the exit node automatically sets itself as the next
	if exit_node:
		next_path_node = self
	
func on_body_entered(body):
	if not body in get_tree().get_nodes_in_group("enemy") and not body in get_tree().get_nodes_in_group("worm"):
		return
	
	if exit_node:
		if body is Caterpillar:
			SignalBus.wave_ended.emit()
			body.queue_free()
		else:
			body.kill_enemy()
		return
	

	body.movement_component.update_target_location(body.navigation_agent_2d, next_path_node.global_position)
