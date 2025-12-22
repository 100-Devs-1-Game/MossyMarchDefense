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
var targeting_worm := false
var worm_target : CharacterBody2D
var is_moving := true

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")
	
	movement_component.update_target_location(navigation_agent_2d, level_manager.get_first_path_node(enemy_type == GlobalEnums.EnemyType.Worm).global_position)
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)
	
func _physics_process(_delta):
	play_animation()
	
	if not is_moving:
		return
	
	if targeting_worm:
		movement_component.update_target_location(navigation_agent_2d, worm_target.global_position)
	
	movement_component.move_to_target(self, navigation_agent_2d)

func load_enemy_stats(enemy_stats : EnemyData):
	enemy_type = enemy_stats.enemy_type
	movement_component.max_movement_speed = enemy_stats.movement_speed
	animated_sprite_2d.sprite_frames = enemy_stats.sprite_frames
	payout = enemy_stats.enemy_payout
	

func kill_enemy():
	if not enemy_type == GlobalEnums.EnemyType.Worm:
		level_manager.adjust_enemies(-1)
		var coin_instance = coin.instantiate()
		level_manager.add_child.call_deferred(coin_instance)
		coin_instance.global_position = self.global_position
	self.queue_free()

func change_target_to_worm(body):
	targeting_worm = true
	worm_target = body

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
			
func control_movement_flag(flag : bool):
	is_moving = flag

func on_body_entered(body):
	if body.is_in_group("worm"):
		is_moving = false
		if not body.invuln:
			body.health_component.get_hit(1)
			body.enter_invuln()
		change_target_to_worm(body)

func on_body_exited(body):
	if body.is_in_group("worm"):
		is_moving = true
