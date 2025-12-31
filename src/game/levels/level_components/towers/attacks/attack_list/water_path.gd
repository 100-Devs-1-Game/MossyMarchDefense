class_name WaterAttackPath extends Path2D

@onready var path_follow : PathFollow2D = $PathFollowMain
@onready var path_follow_visual_1 : PathFollow2D = $PathFollowVisual1
@onready var path_follow_visual_2 : PathFollow2D = $PathFollowVisual2

var progress : float = 0.0
var total_length : float = 0.0

var damage : int = 1
var speed : float = 0.0

func initialise(marker : Node2D, enemy : Node2D, set_damage:int, set_speed:float) -> void:
	curve = Curve2D.new()
	damage = set_damage
	speed = set_speed
	
	var attack_position = marker.global_position
	var enemy_position = enemy.global_position
	
	var arc_height = 35
	var mid_x = (attack_position.x + enemy_position.x) / 2.0
	var top_y = min(attack_position.y, enemy_position.y) - arc_height
	
	var mid_position = Vector2(mid_x, top_y)
	
	var curve_mod_x = (attack_position.x - enemy_position.x) / 4.0
	var curve_mod_y = abs(top_y - enemy_position.y) / 2.0
	
	curve.add_point(attack_position)
	curve.add_point(mid_position, curve_mod_x * Vector2.RIGHT, curve_mod_x * Vector2.LEFT)
	curve.add_point(enemy_position, curve_mod_y * Vector2.UP)
	curve.add_point(enemy_position + Vector2.DOWN * 1080)
	
	total_length = curve.get_baked_length()


func _process(delta: float) -> void:
	progress += delta * speed
	
	var progress_ratio = progress / total_length
	var progress_ratio_visual_1 = (progress - (speed * 0.2)) / total_length  # 0.2 seconds behind
	var progress_ratio_visual_2 = (progress - (speed * 0.4)) / total_length  # 0.4 seconds behind
	
	path_follow.progress_ratio = ease(progress_ratio, 0.9)
	path_follow_visual_1.progress_ratio = ease(progress_ratio_visual_1, 0.92)
	path_follow_visual_2.progress_ratio = ease(progress_ratio_visual_2, 0.94)
	
	if progress_ratio >= 0.8:
		queue_free()


func _on_hitbox_entered(body: Node2D):
	if body is Enemy:
		body.damage_enemy(damage)
