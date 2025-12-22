@tool

extends Node2D

@export var speed : float = 0.5

@export_tool_button("Redraw line") var redraw_line_tool_button = refresh_line

@onready var path : Path2D = $Path2D
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D

@onready var marker : Marker2D = $Tower/Marker2D
@onready var enemy : Node2D = $Enemy

var progress : float = 0.0

func _process(delta: float) -> void:
	var length = path.curve.get_baked_length()
	
	progress += delta * speed
	progress = fmod(progress, length)
	
	var progress_ratio = progress / length
	
	path_follow.progress_ratio = ease(progress_ratio, 0.75)
	
func refresh_line() -> void:
	var curve = path.curve
	
	curve.clear_points()
	
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
