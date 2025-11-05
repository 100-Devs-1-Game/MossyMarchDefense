extends AnimatedSprite2D

##Just a silly little script for a silly little bird.
#animates a simple randomized rotation

var rot

func _ready() -> void:
	var r = randf_range(0.0, 0.3)
	rot = randf_range(-57.0, 57.0)
	await get_tree().create_timer(r).timeout
	play("speeeeen")

func _process(delta: float) -> void:
	if frame == 2: #just a lazy way to make borb look like its spinning
		flip_h = true
	else:
		flip_h = false

	rotation_degrees += rot * delta
