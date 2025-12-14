class_name BaseAttack

extends Node2D

var attack_source: Marker2D
var enemies_in_range: Array[Node2D]

func initialise(attack_source_in: Marker2D, enemies_in_range_in: Array[Node2D]):
	attack_source = attack_source_in
	enemies_in_range = enemies_in_range_in
