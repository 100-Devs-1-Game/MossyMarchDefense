extends Node

const MUSIC = GlobalEnums.MusicTitle
const SFX = GlobalEnums.SFXTitle

const MUSIC_DICTIONARY = {
	MUSIC.MainMenu : preload("res://assets/Audio/Music/main-menu-bgm.ogg"),
	MUSIC.Level1 : preload("res://assets/Audio/Music/mossy_march_lvl1.ogg"),
	MUSIC.Level2 : preload("res://assets/Audio/Music/mossy_march_lvl2.ogg"),
	MUSIC.Level3 : preload("res://assets/Audio/Music/mossy_march_lvl3.ogg")
}

const SFX_DICTIONARY = {
	SFX.MobDefeat : 
		[preload("res://assets/Audio/SFX/SFX Archive/mob-defeat.ogg"),
		preload("res://assets/Audio/SFX/SFX Archive/mob-defeat2.ogg")],
	SFX.MobImpact : preload("res://assets/Audio/SFX/SFX Archive/mob-impact.ogg"),
	SFX.UIConfirm :
		[ preload("res://assets/Audio/SFX/SFX Archive/ui-confirm.ogg"),
		 preload("res://assets/Audio/SFX/SFX Archive/ui-confirm2.ogg"),
		 preload("res://assets/Audio/SFX/SFX Archive/ui-confirm3.ogg"),
		 preload("res://assets/Audio/SFX/ui_confirm.ogg")], # TODO: idk why we got this extra ui confirm

	SFX.LevelFail : preload("res://assets/Audio/SFX/level_fail.ogg"),
	SFX.LevelSuccess : preload("res://assets/Audio/SFX/level_success.ogg"),
	SFX.PollenAttack : preload("res://assets/Audio/SFX/pollen.ogg"),
	SFX.WaterCanAttack : {
		1 : preload("res://assets/Audio/SFX/watercan1.ogg"),
		2 : preload("res://assets/Audio/SFX/watercan2.ogg")
	},
	SFX.WaveStart : preload("res://assets/Audio/SFX/wave_start.ogg"),
	SFX.TowerPlace : preload("res://assets/Audio/SFX/SFX Archive/tower-place.ogg")
}

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	music_player.bus = &"Music"
	assert(AudioServer.get_bus_index(music_player.bus) >= 0)
	
func play_music(music : GlobalEnums.MusicTitle) -> void:
	
	var selected_song = MUSIC_DICTIONARY[music]
	
	if music_player.stream != null and selected_song == music_player.stream:
		return
	
	music_player.stream = selected_song
	music_player.play()

func apply_reverb(flag : bool) -> void:
	# Says reverb but Im doing high pass filter lol
	var music_bus = AudioServer.get_bus_index(&"Music")
	
	AudioServer.set_bus_effect_enabled(music_bus, 0, flag)

func play_sfx(sfx : GlobalEnums.SFXTitle) -> void:
	
	var selected_sfx
	
	if sfx == SFX.MobDefeat or sfx == SFX.WaterCanAttack or sfx == SFX.UIConfirm:
		var i = randi_range(0, SFX_DICTIONARY[sfx].size() - 1)
		selected_sfx = SFX_DICTIONARY[sfx][i]
	else:
		selected_sfx = SFX_DICTIONARY[sfx]
	
	var audioplayer := AudioStreamPlayer.new()
	audioplayer.name = "AudioSFX " + selected_sfx.resource_path.get_file()
	add_child(audioplayer)
	audioplayer.finished.connect(func(): audioplayer.queue_free())
	
	audioplayer.stream = selected_sfx
	audioplayer.bus = &"SFX"
	audioplayer.play()
