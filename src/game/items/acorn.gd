extends Node2D

@onready var area_2d = $Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var clickable := false



func _ready():
	area_2d.mouse_entered.connect(on_mouse_entered)
	area_2d.mouse_exited.connect(on_mouse_exited)
	animated_sprite_2d.play()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and clickable:
		var level_manager = get_tree().get_first_node_in_group("level_manager")
		level_manager.pay_player(1)
		self.queue_free()

func on_mouse_entered():
	clickable = true
	
func on_mouse_exited():
	clickable = false
