class_name HealthBar

extends Sprite2D

func update_health(current_health: int, base_health: int):
	var current_health_percent = current_health / float(base_health)
	var remaining_health_percent = (base_health - current_health) / float(base_health)
	
	var texture_width = texture.get_width()
	var remaining_width = texture_width * remaining_health_percent
	
	$Fill.scale.x = current_health_percent
	$Fill.position.x = -remaining_width / 2
