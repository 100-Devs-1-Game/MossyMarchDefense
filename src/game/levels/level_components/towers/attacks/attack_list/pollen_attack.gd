extends BaseAttack

@onready var particles : CPUParticles2D = $CPUParticles2D

var attack_interval : float = 5.0

func shoot():
	attack_audio.play()
	particles.emitting = true
	
	for enemy in enemies_in_range:
		enemy.health_component.get_hit(5)
