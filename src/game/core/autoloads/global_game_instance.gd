extends Node

const LEVEL_PATHS : Dictionary = {
	"level_01" : ""
}

const STARTING_ACORNS = 14

var current_level:Node = null
var acorns:int = STARTING_ACORNS

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	SignalBus.acorns_gained.connect(_on_acorns_gained)
	SignalBus.acorns_spent.connect(_on_acorns_spent)

func _on_acorns_gained(amt:int) -> void:
	acorns += amt
	SignalBus.acorns_updated.emit(amt)

func _on_acorns_spent(amt:int) -> void:
	acorns = clampi((acorns - amt), 0, 999)
	SignalBus.acorns_updated.emit(-amt)


func _change_to_level() -> void:
	pass

func get_acorns() -> int:
	return acorns

func set_current_level(new_level:Node) -> void:
	current_level = new_level
	
	if current_level != null:
		_setup_the_acorn_gobbler_3000()
	

func reset_current_level() -> void:
	acorns = STARTING_ACORNS

# This is not the best way at all to handle this. - Phoenix
# Once level class is created; it needs to not be this crazy stuff I made.
# Comment out these functions when/if they break your testing.
func _setup_the_acorn_gobbler_3000() -> void:
	
	var the_acorn_gobbler:Node = null
	if current_level.has_node("LevelManager"):
		the_acorn_gobbler = current_level.get_node("LevelManager")
		
	the_acorn_gobbler.child_entered_tree.connect(func(nut:Node):
		if nut is Node2D:
			var t = get_tree().create_tween()
			t.finished.connect(func(): nut.queue_free())
			t.tween_property(nut, "global_position", Vector2(93, 88), 1.0)
			
		)
	
	var the_acorn_gobblers_victims:Node = null
	
	if current_level.has_node("Enemies"):
		the_acorn_gobblers_victims = current_level.get_node("Enemies")
		
	the_acorn_gobblers_victims.child_entered_tree.connect(func(goober:Node):
		if goober.has_method("kill_enemy"):
			goober.tree_exiting.connect(func():
				SignalBus.acorns_gained.emit(goober.payout))
		)
