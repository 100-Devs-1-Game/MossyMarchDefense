class_name Enemy extends CharacterBody2D
signal killed(body:Enemy)

@export_category("Enemy Stats")
@export var health : int = 10
@export var base_damage : int = 1
@export var attack_cooldown : float = 2.0
@export var base_movespeed : float = 20.0
@export var acorn_payout : int = 0

# Core on ready node references
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var _healthbar: ProgressBar = %Healthbar
@onready var _hitbox_root: Node2D = %HitboxRoot

# Health Setters/Getters Update
var max_hp : int:
	set(val):
		max_hp = val
		_healthbar.max_value = max_hp
		curr_hp = max_hp
var curr_hp : int:
	set(val):
		curr_hp = val
		_healthbar.value = val
		if curr_hp <= 0:
			_kill_enemy()

# Effective MS - NOTE: Maybe we add slow towers; so we want this buffer. -Phoenix
var effective_move_speed : float = 0.0

# Set References - For Movement Logic
var _node_array : Array[Node] = []
var _target : Caterpillar = null

# Move Logic Vars
var _next_target_target_node : Node = null  # Changed from PathNode to Node
var _is_attacking : bool = false
const _MIN_DIS_TO_TARGET : float = 10.0  # Increased to match Caterpillar

# Almighty Acorn
const ACORN = preload("uid://c57niq1ophbeq")

# Safety vars
var done_spawning : bool = false
var dying : bool = false

# Animation state tracking
var _attack_animation_playing : bool = false

func spawn_in(target:Caterpillar, path_nodes:Array[Node]) -> void:
	
	# Some cleanup + failsafe.
	if Instance.current_level.level_failed:
		self.queue_free()
	SignalBus.level_failed.connect(func(): self.queue_free())
	
	
	_set_stats_from_export()
	_target = target
	_node_array = path_nodes
	
	# Set effective move speed to base value initially
	effective_move_speed = base_movespeed
	
	if path_nodes.size() > 0:
		_next_target_target_node = path_nodes[0]
		global_position = _next_target_target_node.global_position
	else:
		_next_target_target_node = null
	
	set_collision_layer_value(2, true)
	done_spawning = true

func _set_stats_from_export() -> void:
	max_hp = health

func _move_to_next_node() -> void:
	# If we have no target node, we've reached the end
	if _next_target_target_node == null:
		_kill_enemy()
		return
	
	# Calculate direction to next node
	var direction = global_position.direction_to(_next_target_target_node.global_position)
	
	# Calculate distance to next node
	var distance = global_position.distance_to(_next_target_target_node.global_position)
	
	# Check if we've reached the current target node
	if distance <= _MIN_DIS_TO_TARGET:
		# Find index of current node using manual search
		var current_index = -1
		for i in range(_node_array.size()):
			if _node_array[i] == _next_target_target_node:
				current_index = i
				break
		
		# If we found the current node and there's a next node
		if current_index != -1 and current_index + 1 < _node_array.size():
			# Move to next node in array
			_next_target_target_node = _node_array[current_index + 1]
			return
		else:
			# No more nodes - attack the target caterpillar
			_next_target_target_node = null
			return
	
	# Set velocity based on direction and move speed
	velocity = direction * effective_move_speed
	
	# Only move if we have a valid next node
	if _next_target_target_node != null:
		move_and_slide()

func _physics_process(delta):
	if dying:
		return
	if not done_spawning:
		return
	
	# Update hitbox rotation
	_update_hitbox()
	
	# Only moves when not attacking. Otherwise attacks; and begins reducing cd to move again.
	if not _is_attacking:
		_move_to_next_node()
		_update_animation() # Only update animation when moving
	else:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			_is_attacking = false
			attack_cooldown = 2.0  # Reset cooldown
			# Resume normal animation
			_attack_animation_playing = false

func _update_hitbox() -> void:
	var current_velocity = velocity
	
	# Only update if we're actually moving
	if current_velocity.length() < 0.1:
		return
	
	# Determine primary movement direction (4 cardinal directions)
	if abs(current_velocity.x) > abs(current_velocity.y):
		# Moving horizontally
		if current_velocity.x > 0:
			# Moving right - hitbox faces right (0 degrees)
			_hitbox_root.rotation = 0
		else:
			# Moving left - hitbox faces left (pi radians / 180 degrees)
			_hitbox_root.rotation = PI
	else:
		# Moving vertically
		if current_velocity.y > 0:
			# Moving down - hitbox faces down (pi/2 radians / 90 degrees)
			_hitbox_root.rotation = PI / 2
		else:
			# Moving up - hitbox faces up (3*pi/2 radians / 270 degrees)
			_hitbox_root.rotation = 3 * PI / 2

func _update_animation() -> void:
	# Don't update animation if we're playing attack animation
	if _attack_animation_playing:
		return
	
	var current_velocity = velocity
	
	if(abs(current_velocity.x) > abs(current_velocity.y)):
		
		_sprite.play(&"walk_side")
		
		if current_velocity.x < 0.0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
	
	else:
		_sprite.flip_h = false
		
		if current_velocity.y > 0.0:
			_sprite.play(&"walk_towards")
		else:
			_sprite.play(&"walk_back")

func _kill_enemy():
	dying = true
	_spawn_acorn()
	killed.emit()

func _spawn_acorn() -> void:
	var acorn_instance : AcornPickup = ACORN.instantiate()
	acorn_instance.amount = acorn_payout
	Instance.current_level.acorns.add_child.call_deferred(acorn_instance)
	acorn_instance.global_position = self.global_position

func _attack() -> void:
	if dying: return
	velocity = Vector2.ZERO
	_is_attacking = true
	
	# Pause current animation and set to frame 0
	if _sprite.is_playing():
		_sprite.pause()
	_sprite.frame = 0
	_attack_animation_playing = true
	
	# Damage the target
	_target.take_damage(base_damage)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if dying: return
	if body is Caterpillar:
		_attack()

func damage_enemy(amount:int) -> void:
	if dying: return
	curr_hp -= amount
