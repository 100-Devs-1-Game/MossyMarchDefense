extends BaseAttack

@onready var water_path = load("res://game/levels/level_components/towers/attacks/water_path.tscn")

func shoot():
	var current_target = get_current_target()
	if !current_target:
		return
			
	var instance = water_path.instantiate()
	instance.initialise(attack_source, current_target)
	get_tree().current_scene.add_child.call_deferred(instance)
	
func get_current_target():
	if enemies_in_range.size() == 0:
		return null
	
	return enemies_in_range[0]
