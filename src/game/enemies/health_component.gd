extends Node

@export var health_bar: HealthBar
@export var base_health: int = 3

var current_health := base_health

func get_hit(damage:int):
	current_health -= damage
	if current_health <= 0:
		get_parent().kill_enemy()
	elif health_bar:
		health_bar.update_health(current_health, base_health)
