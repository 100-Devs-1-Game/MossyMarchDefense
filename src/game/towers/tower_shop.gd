extends Node2D

@export var tower_parent : Node2D

func _ready() -> void:
	$TowerPlacement.tower_parent = tower_parent
	
	$Plant.on_dragged.connect($TowerPlacement._on_plant_on_dragged)
