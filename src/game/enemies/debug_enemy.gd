extends Node2D


@onready var movement_component = $MovementComponent
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var health_component = $HealthComponent
@onready var enemy_type : GlobalEnums.EnemyType = GlobalEnums.EnemyType.Frog

var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")
	
	movement_component.update_target_location(navigation_agent_2d, level_manager.get_first_path_node().global_position)

func _physics_process(delta):
	movement_component.move_to_target(self, navigation_agent_2d)

func kill_enemy():
	level_manager.adjust_enemies(-1)
	self.queue_free()
