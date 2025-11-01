extends Node2D


@onready var movement_component = $MovementComponent
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var health_component = $HealthComponent
@onready var sprite_2d = $Sprite2D


var enemy_type : GlobalEnums.EnemyType
var payout : int
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")
	
	movement_component.update_target_location(navigation_agent_2d, level_manager.get_first_path_node().global_position)
	
func _physics_process(delta):
	movement_component.move_to_target(self, navigation_agent_2d)

func load_enemy_stats(enemy_stats : EnemyData):
	enemy_type = enemy_stats.enemy_type
	movement_component.max_movement_speed = enemy_stats.movement_speed
	sprite_2d.texture = enemy_stats.enemy_sprite
	payout = enemy_stats.enemy_payout

func kill_enemy():
	level_manager.adjust_enemies(-1)
	level_manager.pay_player(payout)
	self.queue_free()
