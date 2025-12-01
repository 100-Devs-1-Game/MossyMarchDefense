extends StaticBody2D

@onready var bullet = load("res://game/towers/debug_projectile.tscn")
var bulletDamage = 10000
var currTargets = []
var currTarget = null
var shootInterval = 1.5
var shootTimer = 0.0

func _ready():
	$Area2D.body_entered.connect(_enter_tower_range)
	$Area2D.body_exited.connect(_exit_tower_range)

func _process(delta):
	if currTarget != null:
		shootTimer -= delta
		if shootTimer <= 0.0:
			shoot()
			shootTimer = shootInterval
	else:
		if currTargets.size() > 0:
			currTarget = currTargets[0]

func shoot():
	if currTarget == null:
		return
		
	var spawn_position = $Marker2D.global_position
	var look_direction = spawn_position.angle_to_point(currTarget.global_position)
	look_direction += PI/2
	
	var instance = bullet.instantiate()
	instance.dir = look_direction
	instance.spawnPos = spawn_position
	instance.spawnRot = look_direction
	instance.base_damage = bulletDamage
	get_tree().current_scene.add_child.call_deferred(instance)

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
