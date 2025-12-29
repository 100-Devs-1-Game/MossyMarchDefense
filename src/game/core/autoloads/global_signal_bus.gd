extends Node

# Game Signals
signal acorns_gained(amount:int)
signal acorns_spent(amount:int)
signal retry_level

# UI Signals
signal start_wave_clicked
signal pause_wave_clicked
signal set_current_wave(wave_number:int)
signal set_current_worms(worm_number:int)
signal worm_damaged(new_hp:int)
signal close_game_hud

# Level Signals
signal level_initialization_complete
signal wave_ended










# Temporary Signals
signal tower_placement_hovered(location:TowerMarker)
signal tower_placement_unhovered(location:TowerMarker)
signal ui_tower_dropped(tower_type:ENUM.TowerType)
