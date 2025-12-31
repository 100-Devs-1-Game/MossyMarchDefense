class_name BubbleProjectile extends CharacterBody2D

var target_direction : Vector2 = Vector2.ZERO
var speed : float = 0.0
var damage : int = 0

func move_to_target(new_dir:Vector2, new_speed: float, set_damage:int) -> void:
	target_direction = new_dir
	speed = new_speed
	damage = set_damage

func _physics_process(_delta: float) -> void:
	if target_direction != Vector2.ZERO:
		velocity = target_direction * speed
		move_and_slide()

func _process(_delta: float) -> void:
	if velocity.length() > 0:
		rotation = velocity.angle()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.damage_enemy(damage)
		self.queue_free()
