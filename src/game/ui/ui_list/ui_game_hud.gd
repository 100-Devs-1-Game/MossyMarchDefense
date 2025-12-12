extends UILayer

@onready var shop_panel: TextureRect = %ShopPanel
@onready var flower_click_space: UITowerChoice = %FlowerClickSpace
@onready var water_click_space: UITowerChoice = %WaterClickSpace
@onready var blob_click_space: UITowerChoice = %BlobClickSpace

@onready var acorn_amount: Label = %AcornAmount

var acorn_raw_count : int = 0

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	SignalBus.acorns_gained.connect(_on_acorns_gained)
	SignalBus.acorns_spent.connect(_on_acorns_spent)
	
	for node in shop_panel.get_children():
		if node is UITowerChoice:
			pass
	

func _on_acorns_gained(amount:int) -> void:
	acorn_raw_count += amount
	acorn_amount.text = str(acorn_raw_count)

func _on_acorns_spent(amount:int) -> void:
	acorn_raw_count -= amount
	acorn_amount.text = str(acorn_raw_count)

func _on_tower_choice_hovered() -> void:
	pass

func _on_tower_choice_unhovered() -> void:
	pass
