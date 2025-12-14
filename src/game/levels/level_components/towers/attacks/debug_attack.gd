extends BaseAttack

@onready var bullet = load("res://game/levels/level_components/towers/attacks/debug_projectile.tscn")

var bulletDamage = 10000

func shoot():
	var current_target = get_current_target()
	if !current_target:
		return
		
	var spawn_position = attack_source.global_position
	var look_direction = spawn_position.angle_to_point(current_target.global_position)
	look_direction += PI/2
	
	var instance = bullet.instantiate()
	instance.dir = look_direction
	instance.spawnPos = spawn_position
	instance.spawnRot = look_direction
	instance.base_damage = bulletDamage
	get_tree().current_scene.add_child.call_deferred(instance)
	
func get_current_target():
	if enemies_in_range.size() == 0:
		return null
	
	return enemies_in_range[0]
