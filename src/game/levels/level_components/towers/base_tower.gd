extends StaticBody2D

@export var tower_data : TowerData

var currTargets = []
var currTarget = null

var attack : Node2D
var attackTimer : float

var attack_dictionary = {
	GlobalEnums.TowerType.PlantPot: preload("res://game/levels/level_components/towers/attacks/debug_attack.tscn"),
	GlobalEnums.TowerType.WateringCan: preload("res://game/levels/level_components/towers/attacks/debug_attack.tscn"),
}

func _ready():
	if tower_data:
		$DetectionArea/CollisionShape2D.shape.radius = tower_data.detection_radius
		$TowerSprite.sprite_frames = tower_data.sprite_frames
		$TowerSprite.play()
		
		attack = attack_dictionary[tower_data.tower_type].instantiate()
		attack.attack_source = $AttackSource
		attackTimer = attack.attack_interval
		add_child.call_deferred(attack)
	
	$DetectionArea.body_entered.connect(_enter_tower_range)
	$DetectionArea.body_exited.connect(_exit_tower_range)

func _process(delta):
	if currTarget != null:
		attackTimer -= delta
		if attackTimer <= 0.0:
			attack.shoot(currTarget)
			attackTimer = attack.attack_interval
	else:
		if currTargets.size() > 0:
			currTarget = currTargets[0]

func _enter_tower_range(body):
	if body.is_in_group("enemy") and body.enemy_type != GlobalEnums.EnemyType.Worm:
		currTargets.append(body)
		if currTarget == null:
			currTarget = body

func _exit_tower_range(body):
	if body in currTargets:
		currTargets.erase(body)
		if body == currTarget:
			currTarget = null
