extends Node

@export var max_movement_speed: float = 5.0
@export var friction: float = 2.0
@export var gravity: float = 9.8
@export var unit_travel := 30.0
@export var target_node: Node2D

var velocity = Vector2.ZERO

func accelerate_in_direction(direction: Vector2):
	velocity = direction * max_movement_speed
	
func update_target_location(nav_agent, target_location):
	nav_agent.set_target_position(target_location)
	
func move_to_target(character_body: CharacterBody2D, nav_agent: NavigationAgent2D):
	var next_location = nav_agent.get_next_path_position()
	var local_location = next_location - character_body.global_position
	var direction = local_location.normalized()
	accelerate_in_direction(direction)
	move(character_body)
	
func move(character_body: CharacterBody2D):
	character_body.velocity.x = velocity.x
	character_body.velocity.y = velocity.y
	character_body.move_and_slide()
	velocity = character_body.velocity
