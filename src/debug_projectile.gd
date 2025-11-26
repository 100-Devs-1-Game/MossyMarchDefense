extends CharacterBody2D

@export var speed = 5

var base_damage = 1
var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(_delta):
	velocity = Vector2(0,-speed).rotated(dir)
	var collision = move_and_collide(velocity)
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("enemy"):
			body.health_component.get_hit(base_damage)
			queue_free()


func _on_timer_timeout():
	queue_free()
