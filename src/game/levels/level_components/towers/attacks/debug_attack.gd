extends Node2D

@onready var bullet = load("res://game/levels/level_components/towers/attacks/debug_projectile.tscn")

@export var attack_source : Marker2D

var attack_interval = 1.5

var bulletDamage = 10000

func shoot(currTarget: Node2D):
	if currTarget == null:
		return
		
	var spawn_position = attack_source.global_position
	var look_direction = spawn_position.angle_to_point(currTarget.global_position)
	look_direction += PI/2
	
	var instance = bullet.instantiate()
	instance.dir = look_direction
	instance.spawnPos = spawn_position
	instance.spawnRot = look_direction
	instance.base_damage = bulletDamage
	get_tree().current_scene.add_child.call_deferred(instance)
