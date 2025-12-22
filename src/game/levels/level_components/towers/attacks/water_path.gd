extends Path2D

@export var speed : float = 0.5

@onready var area : Area2D = $PathFollow2D/Sprite2D/Area2D
@onready var path_follow : PathFollow2D = $PathFollow2D

var progress : float = 0.0

func initialise(marker : Node2D, enemy : Node2D) -> void:
	curve = Curve2D.new()
	
	var attack_position = marker.global_position
	var enemy_position = enemy.global_position
	
	var mid_x = (attack_position.x + enemy_position.x) / 2.0
	var top_y = min(attack_position.y, enemy_position.y) - 50
	
	var mid_position = Vector2(mid_x, top_y)
	
	var curve_mod_x = (attack_position.x - enemy_position.x) / 4.0
	var curve_mod_y = abs(top_y - enemy_position.y) / 2.0
	
	curve.add_point(attack_position)
	curve.add_point(mid_position, curve_mod_x * Vector2.RIGHT, curve_mod_x * Vector2.LEFT)
	curve.add_point(enemy_position, curve_mod_y * Vector2.UP)
	curve.add_point(enemy_position + Vector2.DOWN * 1080)
	
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
