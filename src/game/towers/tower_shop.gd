extends Node2D

@export var tower_parent : Node2D

func _ready() -> void:
	$TowerPlacement.tower_parent = tower_parent
	
	$Plant.on_dragged.connect($TowerPlacement.on_tower_dragged)
	$WateringCan.on_dragged.connect($TowerPlacement.on_tower_dragged)
