extends Node2D

@onready var area_2d = $Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var clickable := false



func _ready():
	animated_sprite_2d.play()
	
	await  get_tree().create_timer(.1).timeout
	
	area_2d.mouse_entered.connect(on_mouse_entered)
	area_2d.mouse_exited.connect(on_mouse_exited)

func _input(event):
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and clickable:
		var level_manager = get_tree().get_first_node_in_group("level_manager")
		level_manager.pay_player(1)
		self.queue_free()

func on_mouse_entered():
	print("Entered!")
	clickable = true
	
func on_mouse_exited():
	clickable = false
