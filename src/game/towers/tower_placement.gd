extends Node2D

@onready var tower = load("res://game/towers/debug_tower.tscn")

@export var tower_parent : Node2D

var is_snapping : bool = false
var dragged_tower_type : GlobalEnums.TowerType
var snap_body : Node2D

var tower_dictionary = {
	GlobalEnums.TowerType.PlantPot: preload("res://resources/tower_data/plant_pot_tower.tres"),
	GlobalEnums.TowerType.WateringCan: preload("res://resources/tower_data/watering_can_tower.tres"),
}

func _ready() -> void:
	$Area2D.body_entered.connect(enter_snap_range)
	$Area2D.body_exited.connect(exit_snap_range)
		
	stop()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if is_snapping:
		$SnapTo.global_position = snap_body.global_position
	else:
		$SnapTo.position = Vector2.ZERO
		
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.is_pressed():
			if is_snapping:
				var tower_instance = tower.instantiate()
				tower_instance.tower_data = tower_dictionary[dragged_tower_type]
				tower_instance.scale = Vector2.ONE
				tower_instance.global_position = snap_body.global_position
				tower_parent.add_child.call_deferred(tower_instance)
				#disable collision
				snap_body.process_mode = Node.PROCESS_MODE_DISABLED
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
	snap_body = body

func exit_snap_range(_body):
	is_snapping = false

func on_tower_dragged(tower_type : GlobalEnums.TowerType) -> void:
	dragged_tower_type = tower_type
	
	var tower_data = tower_dictionary[tower_type]
	$SnapTo/TowerGhost.texture = tower_data.sprite
	$SnapTo/TowerRange.scale = tower_data.detection_radius / 100.0 * Vector2.ONE
	
	start()
