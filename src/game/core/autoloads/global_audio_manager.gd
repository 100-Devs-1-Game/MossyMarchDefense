
extends Node
## Audio Manager

const SONG_PATHS : Dictionary = {
	"main_menu" : "res://assets/Audio/Music/main-menu-bgm.ogg",
	"level_01" : "res://assets/Audio/Music/mossy_march_lvl1.ogg",
	"level_02" : "res://assets/Audio/Music/mossy_march_lvl2.ogg",
	"level_03" : "res://assets/Audio/Music/mossy_march_lvl3.ogg",
}

# Audio Player
enum Music {MainMenu, Level1, Level2, Level3}

var current_audio : AudioStreamPlayer = null
var fading_audio : AudioStreamPlayer = null
var ui_audio : AudioStreamPlayer = null

var _fade_in_tween : Tween = null
var _fade_out_tween : Tween = null

const FADE_TIME : float = 1.0
const FADE_VAL : float = -61.0 # Project Settings disable audio under -60. So we lerp to -61.

func _autoload_initialized() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ui_audio =  AudioStreamPlayer.new()
	self.add_child(ui_audio)

func _connect_signals() -> void:
	pass

## Simple function that connects ENUM -> String.
func play_level_song(music:Music) -> void:
	match music:
		Music.MainMenu:
			play_new_song("main_menu")
		Music.Level1:
			play_new_song("level_01")
		Music.Level2:
			play_new_song("level_02")
		Music.Level3:
			play_new_song("level_03")

func play_new_song(song_key:String) -> void:
	if SONG_PATHS.has(song_key) == false: return
	
	if current_audio:
		fade_out_song(current_audio)
	
	var NEW_SONG : AudioStream = load(SONG_PATHS[song_key])
	current_audio = AudioStreamPlayer.new()
	self.add_child(current_audio)
	current_audio.volume_db = FADE_VAL
	current_audio.stream = NEW_SONG
	current_audio.bus = "MUSIC"
	fade_in_song(current_audio)

func fade_out_song(audio_player:AudioStreamPlayer) -> void:
	if _fade_out_tween:
		_fade_out_tween.kill()
		if fading_audio:
			fading_audio.queue_free()
	fading_audio = current_audio
	_fade_out_tween = get_tree().create_tween()
	_fade_out_tween.tween_property(audio_player, "volume_db", FADE_VAL, FADE_TIME)

func fade_in_song(audio_player:AudioStreamPlayer) -> void:
	audio_player.play()
	if _fade_in_tween: _fade_in_tween.kill()
	_fade_in_tween = get_tree().create_tween()
	_fade_in_tween.tween_property(audio_player, "volume_db", -15, FADE_TIME)

func _process(_delta: float) -> void:
	if fading_audio:
		if fading_audio.volume_db <= FADE_VAL:
			fading_audio.queue_free()


func play_ui_sound(ui_stream:AudioStream) -> void:
	ui_audio.stream = ui_stream
	ui_audio.play()


func toggle_highpass_filter(flag : bool) -> void:
	# Says reverb but Im doing high pass filter lol
	var music_bus = AudioServer.get_bus_index(&"Music")
	AudioServer.set_bus_effect_enabled(music_bus, 0, flag)
