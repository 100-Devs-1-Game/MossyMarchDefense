extends BaseAttack


@onready var particles : CPUParticles2D = $CPUParticles2D

func shoot():
	attack_audio.play()
	particles.emitting = true
	
	for enemy in enemies_in_range:
		enemy.damage_enemy(base_damage)
