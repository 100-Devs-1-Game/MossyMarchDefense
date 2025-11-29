extends Node2D

var timer: float = 0
var flip: bool = false

func _process(delta: float) -> void:
	timer += delta
	if timer >= 0.5:
		flip = !flip
		timer = 0
		
	$rain_layer_1.visible = flip
	$rain_layer_2.visible = !flip
