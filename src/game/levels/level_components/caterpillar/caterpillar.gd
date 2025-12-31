class_name Caterpillar extends CharacterBody2D
signal reached_end
signal killed

@export_category("Caterpillar Stats")
@export var move_speed : float = 30.0

# Health with setter
var worm_health : int = 0:
	set(val):
		worm_health = val
		_healthbar.value = worm_health
		if worm_health <= 0 and worm_health != -1:
			worm_health = -1  # Prevent multiple death calls
			SignalBus.level_failed.emit()
			queue_free()

@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var _healthbar: ProgressBar = %Healthbar

# Movement properties
var _node_array : Array[Node] = []
var _next_target_node : Node = null
const _MIN_DIS_TO_TARGET : float = 10.0

# State tracking
var _is_running : bool = false
var _has_reached_end : bool = false

# Tween for damage effect
var _damage_tween: Tween = null

func setup(initial_node: int, path_nodes: Array[Node], initial_health: int) -> void:
	_node_array = path_nodes
	worm_health = initial_health
	_healthbar.max_value = initial_health
	
	# Initialize movement starting from the specified initial node
	if _node_array.size() > 0:
		# Ensure initial_node is within bounds
		if initial_node < 0:
			initial_node = 0
		elif initial_node >= _node_array.size():
			initial_node = _node_array.size() - 1
		
		_next_target_node = _node_array[initial_node]
		global_position = _next_target_node.global_position

func start_running() -> void:
	_is_running = true
	
	# Ensure we have a target if not set
	if _next_target_node == null and _node_array.size() > 0:
		_next_target_node = _node_array[0]

func _physics_process(_delta: float) -> void:
	if not _is_running:
		return
	
	_move_to_next_node()
	_play_animation()

func _move_to_next_node() -> void:
	# If we have no target node, check if we reached end
	if _next_target_node == null:
		if not _has_reached_end:
			_has_reached_end = true
			reached_end.emit()
		return
	
	# Calculate direction and distance to next node
	var direction = global_position.direction_to(_next_target_node.global_position)
	var distance = global_position.distance_to(_next_target_node.global_position)
	
	# Check if we've reached the current target node
	if distance <= _MIN_DIS_TO_TARGET:
		# Find index of current node
		var current_index = -1
		for i in range(_node_array.size()):
			if _node_array[i] == _next_target_node:
				current_index = i
				break
		
		# If we found the current node and there's a next node
		if current_index != -1:
			# Check if this is the last node
			if current_index + 1 < _node_array.size():
				# Move to next node in array
				_next_target_node = _node_array[current_index + 1]
				return
			else:
				# This is the last node - we reached the end
				_next_target_node = null
				if not _has_reached_end:
					_has_reached_end = true
					reached_end.emit()
				return
	
	# Set velocity and move
	velocity = direction * move_speed
	move_and_slide()

func _play_animation():
	if velocity.length() < 0.1:
		# If not moving, play idle or walk_towards as default
		_sprite.play(&"walk_towards")
		_sprite.flip_h = false
		return
	
	if(abs(velocity.x) > abs(velocity.y)):
		
		_sprite.play(&"walk_side")
		
		if velocity.x < 0.0:
			_sprite.flip_h = true
		else:
			_sprite.flip_h = false
	
	else:
		_sprite.flip_h = false
		
		if velocity.y > 0.0:
			_sprite.play(&"walk_towards")
		else:
			_sprite.play(&"walk_back")

# Damage function
func take_damage(damage_amount: int) -> void:
	if not _has_reached_end:
		if worm_health > 0:
			worm_health -= damage_amount
			_play_damage_effect()

func _play_damage_effect() -> void:
	# Stop any existing tween
	if _damage_tween and _damage_tween.is_valid():
		_damage_tween.kill()
	
	# Create new tween
	_damage_tween = create_tween()
	_damage_tween.set_trans(Tween.TRANS_QUINT)
	_damage_tween.set_ease(Tween.EASE_OUT)
	
	# Flash red and back to white
	_damage_tween.tween_property(_sprite, "modulate", Color(1.0, 0.485, 0.485, 1.0), 0.1)
	_damage_tween.tween_property(_sprite, "modulate", Color.WHITE, 0.2)
