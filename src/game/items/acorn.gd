class_name AcornPickup extends Node2D

@onready var mouse_area: Area2D = %MouseArea
var pickup_timer : float = 0.1
var amount : int = 0

func _on_mouse_entered():
	if pickup_timer >= 0.0:
		pickup_timer = -1.0

func _pick_up_acorn() -> void:
	if pickup_timer >= 0.0:
		pickup_timer = -1.0
		mouse_area.call_deferred("input_pickable", false)

func _process(delta: float) -> void:
	pickup_timer -= 1.0 * delta
	if pickup_timer <= 0.0:
		position = position.move_toward(Vector2.ZERO, 500 * delta)
		if position.is_zero_approx():
			SignalBus.acorns_gained.emit(amount)
			self.queue_free()
