extends Node

# Instance Signals
signal acorns_updated(new_total:int)

# Game Signals
signal acorns_gained(amount:int)
signal acorns_spent(amount:int)

# UI Signals
signal start_wave_clicked
signal pause_wave_clicked
signal set_current_wave(wave_number:int)
signal set_current_worms(worm_number:int)
signal player_damaged(new_hp:int)

# Temporary Signals
signal tower_placement_hovered(location:TowerMarker)
signal tower_placement_unhovered(location:TowerMarker)
signal ui_tower_dropped(tower_type:GlobalEnums.TowerType)
