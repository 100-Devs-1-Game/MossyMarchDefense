extends BaseAttack

@export_category("Specific Settings")
@export var bullet_speed : float = 150.0

const BUBBLE_PROJECTILE = preload("uid://c1gpf8tyar7pq")

func shoot():
	attack_audio.play()
	var current_target = get_current_target()
	if !current_target:
		return
	
	var new_bullet:BubbleProjectile = BUBBLE_PROJECTILE.instantiate()
	
	# Calculate direction to target
	var direction_to_target = (current_target.global_position - global_position).normalized()
	
	# Pass the direction to the projectile
	new_bullet.move_to_target(direction_to_target, bullet_speed, base_damage)
	
	Instance.current_level.bullets.add_child.call_deferred(new_bullet)
	# Make sure to set the position after adding as child
	if not new_bullet.is_inside_tree():
		await new_bullet.tree_entered
	new_bullet.global_position = global_position


func get_current_target():
	if enemies_in_range.size() == 0:
		return null
	
	return enemies_in_range[0]


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is BubbleProjectile:
		body.queue_free()
