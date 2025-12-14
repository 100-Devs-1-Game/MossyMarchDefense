extends UILayer

@onready var menu_anims: AnimationPlayer = %MenuAnims
@onready var shop_panel: TextureRect = %ShopPanel

@onready var acorn_amount: Label = %AcornAmount

var tower_choices : Array[UITowerChoice] = []
var acorn_raw_count : int = 0
var display_acorn_count : int = 0
var tween: Tween
var feedback_tween: Tween

var clicked_tower : UITowerChoice = null
var dragged_tower : UITowerChoice = null
var hovered_placement : TowerMarker = null

var is_dragging : bool = false
var drag_preview : Control = null

const WOB_SPD: float = 8.0
const WOB_AMT: float = 5.0
var _wob_time: float = 0.0
var _wob_angle: float = 0.0

const COUNT_INTERVAL: float = 0.05

func _ready() -> void:
	acorn_raw_count = Instance.get_acorns()
	acorn_amount.text = str(acorn_raw_count)
	display_acorn_count = acorn_raw_count
	_connect_signals()
	menu_anims.play(&"hud_spawned_in")

func _connect_signals() -> void:
	SignalBus.acorns_updated.connect(_on_acorns_updated)
	SignalBus.tower_placement_hovered.connect(_on_tower_placement_hovered)
	SignalBus.tower_placement_unhovered.connect(_on_tower_placement_unhovered)
	
	for node in shop_panel.get_children():
		if node is UITowerChoice:
			tower_choices.append(node)
			node.gui_input.connect(_on_gui_input.bind(node))
			node.mouse_entered.connect(_on_tower_choice_hovered.bind(node))
			node.mouse_exited.connect(_on_tower_choice_unhovered.bind(node))

func _process(delta: float) -> void:
	if is_dragging_tower() and drag_preview_active():
		drag_preview.position = get_viewport().get_mouse_position()
		_drag_wobble(delta)

func _drag_wobble(delta:float) -> void:
	if not drag_preview_active():
		return
	
	_wob_time += delta
	_wob_angle = sin(_wob_time * WOB_SPD) * deg_to_rad(WOB_AMT)
	drag_preview.rotation = _wob_angle

func _on_tower_placement_hovered(location:TowerMarker) -> void:
	hovered_placement = location
	if is_dragging_tower():
		hovered_placement.toggle_placement_preview(dragged_tower, true)

func _on_tower_placement_unhovered(_location:TowerMarker) -> void:
	_clear_placement_preview()

func _on_gui_input(event: InputEvent, tower:UITowerChoice) -> void:
	if event.is_action_pressed(&"ui_left_click"):
		if tower.is_disabled():
			_shake_tower(tower)
			return
		else:
			_update_clicked_tower(tower)

	if event.is_action_released(&"ui_left_click"):
		_handle_release_click()

	if event is InputEventMouseMotion and not is_dragging_tower() and is_tower_clicked():
		_begin_drag()

func _update_clicked_tower(tower:UITowerChoice):
	clicked_tower = tower

func _begin_drag() -> void:
	menu_anims.play(&"hide_shop")
	is_dragging = true
	dragged_tower = clicked_tower
	_wob_time = 0.0
	_create_drag_preview()

func _handle_release_click() -> void:
	if clicked_tower: 
		clicked_tower = null
	
	if is_dragging_tower():
		menu_anims.play(&"hide_shop", -1, -1.0, true)
		
		if hovered_placement != null and hovered_placement.occupied == false:
			hovered_placement.tower_placed(dragged_tower.tower_type)
		
		dragged_tower = null
	
	if drag_preview_active():
		drag_preview.queue_free()
	
	# Always clear any active preview
	_clear_placement_preview()

func _clear_placement_preview() -> void:
	if hovered_placement:
		hovered_placement.toggle_placement_preview(null, false)
		hovered_placement = null

func _create_drag_preview() -> void:
	drag_preview = Control.new()
	var _drag_texture: TextureRect = TextureRect.new()
	
	drag_preview.set_as_top_level(true)
	drag_preview.z_index = 100
	
	drag_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_drag_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_drag_texture.texture = dragged_tower.tower_icon
	_drag_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	var _size: Vector2 = Vector2(150, 150)
	_drag_texture.custom_minimum_size = _size
	_drag_texture.size = _size
	
	_drag_texture.position = -(_size / 2.0)
	_drag_texture.modulate.a = 0.8
	
	drag_preview.add_child(_drag_texture)
	self.add_child(drag_preview)

func _on_acorns_updated(amount:int) -> void:
	var old_count = acorn_raw_count
	acorn_raw_count += amount
	_start_count_animation(old_count, acorn_raw_count, amount)
	_update_selectable_towers()

func _update_selectable_towers() -> void:
	for tower in tower_choices:
		if RES_DATA.get_cost_from_enum(tower.tower_type) > Instance.get_acorns():
			tower.set_disabled_state(true)
			tower.scaled_texture.modulate = Color(0.0, 0.0, 0.0, 0.502)
		else:
			tower.set_disabled_state(false)
			tower.scaled_texture.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _start_count_animation(old_value: int, new_value: int, change: int) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	var total_steps = abs(new_value - old_value)
	var animation_time = total_steps * COUNT_INTERVAL
	
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(_update_display_count, float(old_value), float(new_value), animation_time)
	
	if change > 0:
		_positive_change_feedback()
	elif change < 0:
		_negative_change_feedback()

func _update_display_count(value: float) -> void:
	display_acorn_count = int(value)
	acorn_amount.text = str(display_acorn_count)

func _positive_change_feedback() -> void:
	if feedback_tween and feedback_tween.is_running():
		feedback_tween.kill()
	
	feedback_tween = get_tree().create_tween()
	feedback_tween.set_parallel(true)
	feedback_tween.tween_property(acorn_amount, "scale", Vector2(1.2, 1.2), 0.1)
	feedback_tween.tween_property(acorn_amount, "modulate", Color(0.227, 0.743, 0.25, 1.0), 0.1)
	
	await feedback_tween.finished
	
	feedback_tween = get_tree().create_tween()
	feedback_tween.tween_property(acorn_amount, "scale", Vector2(1.0, 1.0), 0.2)
	feedback_tween.parallel().tween_property(acorn_amount, "modulate", Color.WHITE, 0.2)

func _negative_change_feedback() -> void:
	if feedback_tween and feedback_tween.is_running():
		feedback_tween.kill()
	
	feedback_tween = get_tree().create_tween()
	feedback_tween.set_parallel(true)
	feedback_tween.tween_property(acorn_amount, "scale", Vector2(0.8, 0.8), 0.1)
	feedback_tween.tween_property(acorn_amount, "modulate", Color(1.0, 0.0, 0.1, 1.0), 0.1)
	
	await feedback_tween.finished
	
	feedback_tween = get_tree().create_tween()
	feedback_tween.tween_property(acorn_amount, "scale", Vector2(1.0, 1.0), 0.2)
	feedback_tween.parallel().tween_property(acorn_amount, "modulate", Color.WHITE, 0.2)

func _shake_tower(target_tower: UITowerChoice) -> void:
	if not target_tower:
		return
	
	var original_x = target_tower.position.x
	var shake_tween = get_tree().create_tween()
	
	# Quick horizontal shake pattern
	shake_tween.tween_property(target_tower, "position:x", original_x + 15, 0.04)
	shake_tween.tween_property(target_tower, "position:x", original_x - 12, 0.03)
	shake_tween.tween_property(target_tower, "position:x", original_x + 8, 0.02)
	shake_tween.tween_property(target_tower, "position:x", original_x - 4, 0.01)
	shake_tween.tween_property(target_tower, "position:x", original_x, 0.01)


func _on_tower_choice_hovered(tower:UITowerChoice) -> void:
	if tower.is_disabled():
		tower.self_modulate = Color(1.0, 0.0, 0.0, 0.2)
	else:
		tower.scale = Vector2(1.1, 1.1)
		tower.self_modulate.a = 1.0

func _on_tower_choice_unhovered(tower:UITowerChoice) -> void:
	tower.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	tower.scale = Vector2(1.0, 1.0)
	tower.self_modulate.a = 0.0

func is_tower_clicked() -> bool:
	return is_instance_valid(clicked_tower)

func is_dragging_tower() -> bool:
	return is_instance_valid(dragged_tower)

func is_hovering_empty_slot() -> bool:
	if hovered_placement == null:
		return false
	else:
		if hovered_placement.occupied:
			return false
		else:
			return true

func drag_preview_active() -> bool:
	return is_instance_valid(drag_preview)
