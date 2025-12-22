extends BaseAttack

@onready var particles : CPUParticles2D = $CPUParticles2D

var attack_interval : float = 5.0

func shoot():
	AudioManager.play_sfx(GlobalEnums.SFXTitle.PollenAttack)
	particles.emitting = true
	
	for enemy in enemies_in_range:
		AudioManager.play_sfx(GlobalEnums.SFXTitle.MobImpact)
		enemy.health_component.get_hit(5)
