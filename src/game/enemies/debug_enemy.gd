extends Node2D


@onready var movement_component = $MovementComponent
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var health_component = $HealthComponent
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D

@export var coin: PackedScene


var enemy_type : GlobalEnums.EnemyType
var payout : int
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")
	
	movement_component.update_target_location(navigation_agent_2d, level_manager.get_first_path_node(enemy_type == GlobalEnums.EnemyType.Worm).global_position)
	
	area_2d.body_entered.connect(on_body_entered)
	
func _physics_process(_delta):
	movement_component.move_to_target(self, navigation_agent_2d)
	play_animation()

func load_enemy_stats(enemy_stats : EnemyData):
	enemy_type = enemy_stats.enemy_type
	movement_component.max_movement_speed = enemy_stats.movement_speed
	animated_sprite_2d.sprite_frames = enemy_stats.sprite_frames
	payout = enemy_stats.enemy_payout

func kill_enemy():
	if not enemy_type == GlobalEnums.EnemyType.Worm:
		level_manager.adjust_enemies(-1)
		var coin_instance = coin.instantiate()
		level_manager.add_child(coin_instance)
		coin_instance.global_position = self.global_position
	self.queue_free()

func play_animation():
	# Ugly if statement block incoming!!! ("Uh Oh!" <--- that's you after reading this)
	
	var current_velocity = movement_component.velocity
	
	if(abs(current_velocity.x) > abs(current_velocity.y)):
		
		animated_sprite_2d.play(&"walk_side")
		
		if current_velocity.x < 0.0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	
	else:
		animated_sprite_2d.flip_h = false
		
		if current_velocity.y > 0.0:
			animated_sprite_2d.play(&"walk_towards")
		else:
			animated_sprite_2d.play(&"walk_back")
			
func on_body_entered(body):
	if body.is_in_group("enemy") and body.enemy_type == GlobalEnums.EnemyType.Worm and enemy_type != GlobalEnums.EnemyType.Worm:
		body.queue_free()
