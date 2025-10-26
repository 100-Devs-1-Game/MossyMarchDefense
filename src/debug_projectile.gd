extends CharacterBody2D

@export var SPEED = 2

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta):
	velocity = Vector2(0,-SPEED).rotated(dir)
	var collision = move_and_collide(velocity)
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("enemy"):
			print("enemy shot")
			queue_free()


func _on_timer_timeout():
	queue_free()
