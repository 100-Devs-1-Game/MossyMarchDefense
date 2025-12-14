extends Node

# Instance Signals
signal acorns_updated(new_total:int)

# Game Signals
signal acorns_gained(amount:int)
signal acorns_spent(amount:int)


# Temporary Signals
signal tower_placement_hovered(location:TowerMarker)
signal tower_placement_unhovered(location:TowerMarker)
signal ui_tower_dropped(tower_type:GlobalEnums.TowerType)
