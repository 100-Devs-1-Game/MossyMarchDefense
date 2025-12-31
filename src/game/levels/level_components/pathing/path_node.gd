class_name PathNode extends Node2D

var next_path_node : Node2D
var exit_node : bool = false
@onready var collision_area: Area2D = %CollisionArea


func on_body_entered(body):
	if exit_node:
		if body is Caterpillar:
			SignalBus.wave_ended.emit()
			body.queue_free()
		else:
			body.kill_enemy()
