extends StaticBody2D

@export var tower_data : TowerData

var enemies_in_range: Array[Node2D] = []

var attack : Node2D

var attack_dictionary = {
	GlobalEnums.TowerType.PlantPot: preload("res://game/levels/level_components/towers/attacks/pollen_attack.tscn"),
	GlobalEnums.TowerType.WateringCan: preload("res://game/levels/level_components/towers/attacks/water_attack.tscn"),
	GlobalEnums.TowerType.Bubble: preload("res://game/levels/level_components/towers/attacks/water_attack.tscn")
}

func _ready():
	if tower_data:
		$DetectionArea/CollisionShape2D.shape.radius = tower_data.detection_radius
		
		$TowerSprite.sprite_frames = tower_data.sprite_frames
		$TowerSprite.play()
		
		$AttackTimer.wait_time = tower_data.attack_interval
		$AttackTimer.timeout.connect(on_attack_timer_timeout)
		
		attack = attack_dictionary[tower_data.tower_type].instantiate()
		attack.initialise($AttackSource, enemies_in_range)
		add_child.call_deferred(attack)
	
	$DetectionArea.body_entered.connect(_enter_tower_range)
	$DetectionArea.body_exited.connect(_exit_tower_range)

func _enter_tower_range(body):
	if is_enemy(body):
		enemies_in_range.append(body)
		
		var is_first_enemy = enemies_in_range.size() == 1
		if is_first_enemy && $AttackTimer.is_stopped():
			attack.shoot()
			$AttackTimer.start()

func _exit_tower_range(body):
	if is_enemy(body):
		enemies_in_range.erase(body)

func is_enemy(body):
	return body.is_in_group("enemy") and body.enemy_type != GlobalEnums.EnemyType.Worm
	
func on_attack_timer_timeout():
	if enemies_in_range.size() == 0:
		$AttackTimer.stop()
	else:
		attack.shoot()
