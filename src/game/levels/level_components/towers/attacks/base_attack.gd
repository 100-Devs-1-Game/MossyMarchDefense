class_name BaseAttack extends Node2D

@onready var attack_audio: AudioStreamPlayer = %AttackAudio
var attack_source: Marker2D
var enemies_in_range: Array[Enemy]

var base_damage : int = 0

func initialize(damage:int, attack_source_in: Marker2D, enemies_in_range_in: Array[Enemy]):
	base_damage = damage
	attack_source = attack_source_in
	enemies_in_range = enemies_in_range_in
