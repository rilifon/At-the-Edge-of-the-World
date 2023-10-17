extends Node

const VERSION = "1.0.0"

var USE_STEAM = false
var remove_distortion = false
var which_ending = 1


func _ready():
	for arg in OS.get_cmdline_args():
		if arg == "--use_steam":
			USE_STEAM = true
