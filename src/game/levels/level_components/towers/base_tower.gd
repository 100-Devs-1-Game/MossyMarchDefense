class_name BaseTower extends Node2D

@export var cost : int
@export var base_damage : int
@export var attack : BaseAttack

@onready var attack_source: Marker2D = %AttackSource
@onready var attack_timer: Timer = %AttackTimer

var enemies_in_range: Array[Enemy] = []


func _ready():
	if attack != null:
		attack.initialize(base_damage, attack_source, enemies_in_range)


func _on_attack_timer_timeout():
	if enemies_in_range.size() == 0:
		attack_timer.stop()
	else:
		attack.shoot()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)
		
		var is_first_enemy = enemies_in_range.size() == 1
		if is_first_enemy && attack_timer.is_stopped():
			attack.shoot()
			attack_timer.start()


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_range.erase(body)
