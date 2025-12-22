extends Node2D

@export var speed : float = 0.5

@onready var path : Path2D = $Path2D
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var path_timer : Timer = $Timer

@onready var marker : Marker2D = $Tower/Marker2D
@onready var enemy : Node2D = $Enemy

var progress : float = 0.0

func _ready() -> void:
	path_timer.timeout.connect(on_timer_timeout)

func _process(delta: float) -> void:
	progress += delta * speed
	progress = fmod(progress, path.curve.get_baked_length())
	
	var progress_ratio = progress / path.curve.get_baked_length()
	
	path_follow.progress_ratio = ease(progress_ratio, 0.75)
	
func on_timer_timeout() -> void:
	var curve = path.curve
	curve.clear_points()
	curve.add_point(marker.global_position)
	curve.add_point(enemy.global_position, Vector2(0, -100), Vector2(0, 100))
	curve.add_point(enemy.global_position + Vector2.DOWN * 100)
