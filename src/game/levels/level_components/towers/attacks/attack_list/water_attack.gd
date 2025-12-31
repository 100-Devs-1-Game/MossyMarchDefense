extends BaseAttack

@onready var water_path = load("res://game/levels/level_components/towers/attacks/attack_list/water_path.tscn")

@export_category("Specific Settings")
@export var water_speed : float = 150.0


func shoot():
	var current_target = get_current_target()
	if !current_target:
		return
			
	var water_atk_path : WaterAttackPath = water_path.instantiate()
	water_atk_path.initialise(attack_source, current_target, base_damage, water_speed)
	Instance.current_level.add_child.call_deferred(water_atk_path)
	
func get_current_target():
	if enemies_in_range.size() == 0:
		return null
	
	return enemies_in_range[0]
