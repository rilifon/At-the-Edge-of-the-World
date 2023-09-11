extends Node

#Bus
enum {MASTER_BUS, BGM_BUS, SFX_BUS}

#SFX
const MAX_SFXS = 10
const SFX_PATH = "res://assets/audio/sfxs_res/"
onready var SFXS = {}
onready var CUR_IDLE_SFX = {}

var cur_sfx_player := 1

func _ready():
	setup_sfxs()

func setup_sfxs():
	var dir = Directory.new()
	if dir.open(SFX_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name != "." and file_name != "..":
				#Found enemy sfx file, creating data on memory
				SFXS[file_name.replace(".tres", "")] = load(SFX_PATH + file_name)
				
			file_name = dir.get_next()
	else:
		push_error("An error occurred when trying to access sfxs path.")
		assert(false)

func get_sfx_player():
	var player = $SFXS.get_node("SFXPlayer"+str(cur_sfx_player))
	cur_sfx_player = (cur_sfx_player%MAX_SFXS) + 1
	return player

func has_sfx(name: String):
	return SFXS.has(name)

func play_sfx(name: String, override_pitch = false):
	if not SFXS.has(name):
		push_error("Not a valid sfx name: " + name)
		assert(false)
	var sfx = SFXS[name]
	var player = get_sfx_player()
	player.stop()
	
	player.stream.audio_stream = sfx.asset
	
	randomize()
	var vol = sfx.base_db + rand_range(-sfx.random_db_var, sfx.random_db_var)
	player.volume_db = vol
	
	if override_pitch:
		override_pitch = max(override_pitch, 0.001)
		player.pitch_scale = override_pitch
	else:
		player.pitch_scale = sfx.base_pitch
	player.stream.random_pitch = 1.0 + sfx.random_pitch_var

	player.play()


func get_sfx_duration(name: String):
	if not SFXS.has(name):
		push_error("Not a valid sfx name: " + name)
		assert(false)
	return SFXS[name].asset.get_length()
