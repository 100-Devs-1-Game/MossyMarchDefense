extends CharacterBody2D


@onready var movement_component = $MovementComponent
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var health_component = $HealthComponent
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d = $Area2D
@onready var invuln_timer = $InvulnTimer

var enemy_type := ENUM.EnemyType.Worm
var payout : int
var level_manager
var invuln := false

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")
	
	movement_component.update_target_location(navigation_agent_2d, Instance.current_level.get_first_path_node(enemy_type == ENUM.EnemyType.Worm).global_position)
	invuln_timer.timeout.connect(on_invuln_timeout)
	
func _physics_process(_delta):
	if not Instance.current_level.between_waves:
		movement_component.move_to_target(self, navigation_agent_2d)
		play_animation()

func load_enemy_stats(enemy_stats : EnemyData):
	enemy_type = enemy_stats.enemy_type
	movement_component.max_movement_speed = enemy_stats.movement_speed
	animated_sprite_2d.sprite_frames = enemy_stats.sprite_frames
	payout = enemy_stats.enemy_payout


func kill_enemy():
	level_manager.lose_game()

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
			
func enter_invuln():
	invuln = true
	invuln_timer.start()
	
func on_invuln_timeout():
	invuln = false
