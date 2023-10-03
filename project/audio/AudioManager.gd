extends Node

#Buses
enum {MASTER_BUS, BGM_BUS, SFX_BUS, NARRATION_BUS}

#Volume
const MUTE_DB = -80 #Muted volume
const CONTROL_MULTIPLIER = 2.5

#SFX
const MAX_SFXS = 50
const SFX_PATH = "res://assets/audio/sfxs_res/"
onready var SFXS = {}
onready var CUR_IDLE_SFX = {}

var cur_sfx_player := 1


func _ready():
	setup_nodes()
	setup_sfxs()


func setup_nodes():
	for _i in range(MAX_SFXS + 1):
		var node = AudioStreamPlayer.new()
		node.stream = AudioStreamRandomPitch.new()
		node.stream.random_pitch = 1.0
		node.bus = "SFX"
		$SFXS.add_child(node)


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
	var player = $SFXS.get_child(cur_sfx_player)
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


# Bus Methods

#Expects a value between 0 and 1
func set_bus_volume(which_bus: int, value: float):
	var db
	if value <= 0.0:
		db = MUTE_DB
	else:
		db = (1-value)*MUTE_DB/CONTROL_MULTIPLIER
	
	if which_bus in [MASTER_BUS, BGM_BUS, SFX_BUS, NARRATION_BUS]:
		AudioServer.set_bus_volume_db(which_bus, db)
	else:
		assert(false, "Not a valid bus to set volume: " + str(which_bus))


func get_bus_volume(which_bus: int):
	if which_bus in [MASTER_BUS, BGM_BUS, SFX_BUS, NARRATION_BUS]:
		return clamp(1.0 - AudioServer.get_bus_volume_db(which_bus)/float(MUTE_DB/CONTROL_MULTIPLIER), 0.0, 1.0)
	else:
		assert(false, "Not a valid bus to set volume: " + str(which_bus))
