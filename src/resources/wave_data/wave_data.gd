class_name WaveData extends Resource

@export var enemy_type : ENUM.EnemyType = ENUM.EnemyType.Snail
@export var amount : int = 10
@export var spawn_interval : float = 1.0
@export var wave_timer : float = -1.0

@export var enemy_queue : Array[String]
@export var enemy_spawn_timer : float = 1.0
