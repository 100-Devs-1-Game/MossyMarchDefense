extends Path2D

@export var speed : float = 0.5

@onready var area : Area2D = $PathFollow2D/Sprite2D/Area2D
@onready var path_follow : PathFollow2D = $PathFollow2D

var progress : float = 0.0

func initialise(marker : Node2D, enemy : Node2D) -> void:
	curve.clear_points()
	
	var in_curve = Vector2(0, -100)
	var out_curve = Vector2(0, 100)
	
	var start_position = marker.global_position
	var end_position = enemy.global_position
	
	var mid_position_x = (start_position.x + end_position.x) / 2.0
	var mid_position_y = min(start_position.y, end_position.y) - 50
	var mid_position = Vector2(mid_position_x, mid_position_y)
	
	var start_to_mid_angle = (mid_position - start_position).angle()
	
	curve.add_point(start_position)
	curve.add_point(mid_position, in_curve.rotated(start_to_mid_angle), out_curve.rotated(start_to_mid_angle))
	curve.add_point(end_position, in_curve, out_curve)
	curve.add_point(end_position + Vector2.DOWN * 100)
	
func _ready() -> void:
	area.body_entered.connect(on_body_entered)
	
func _process(delta: float) -> void:
	var length = curve.get_baked_length()
	
	progress += delta * speed
	if progress > length:
		queue_free()
	
	var progress_ratio = progress / length
	
	path_follow.progress_ratio = ease(progress_ratio, 0.75)

func on_body_entered(other: Node2D):
	if other.is_in_group("enemy"):
			other.health_component.get_hit(2)
