extends Node2D

@onready var tower = load("res://game/towers/debug_tower.tscn")

@export var debug : bool = false

var is_snapping = false
var snap_global_position

func _ready() -> void:
	$Area2D.body_entered.connect(enter_snap_range)
	$Area2D.body_exited.connect(exit_snap_range)
	
	$"../Plant".on_dragged.connect(_on_plant_on_dragged)
	
	if !debug:
		stop()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if is_snapping:
		$SnapTo.global_position = snap_global_position
	else:
		$SnapTo.position = Vector2.ZERO
		
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.is_pressed():
			if is_snapping:
				var tower_instance = tower.instantiate()
				tower_instance.global_position = snap_global_position
				tower_instance.scale = Vector2.ONE
				get_tree().current_scene.add_child.call_deferred(tower_instance)
			stop()
	
func start() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	is_snapping = false
	
func stop() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
	is_snapping = false
	
func enter_snap_range(body):
	is_snapping = true
	snap_global_position = body.global_position

func exit_snap_range(_body):
	is_snapping = false

func _on_plant_on_dragged(mouse_offset: Vector2) -> void:
	start()
