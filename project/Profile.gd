extends Node

const LANGUAGES = [
	{"locale":"en", "name": "English"},
	{"locale":"pt_BR", "name": "Português"},
]


var options = {
	"master_volume": 0.55,
	"bgm_volume": 1.0,
	"sfx_volume": 1.0,
	"narration_volume": 1.0,
	"fullscreen": false,
	"dummy_slider": .75,
}

var stats = {
	"times_completed": 0,
	"end1_done": false,
	"end2_done": false,
}

func get_locale_idx(locale):
	var idx = 0
	for lang in LANGUAGES:
		if lang.locale == locale:
			return idx
		idx += 1
	push_error("Couldn't find given locale: " + str(locale))


func update_translation():
	TranslationServer.set_locale(LANGUAGES[get_option("locale")].locale)


func get_save_data():
	var data = {
		"time": OS.get_datetime(),
		"version": Global.VERSION,
		"options": options,
		"stats": stats,
	}
	
	return data


func set_save_data(data):
	if data.version != Global.VERSION:
		#Handle version diff here.
		push_warning("Different save version for profile. Its version: " + str(data.version) + " Current version: " + str(Global.VERSION)) 
		push_warning("Properly updating to new save version")
		push_warning("Profile updated!")#ヽ(*￣▽￣*)ノミ
	
	set_data(data, "options", options)
	set_data(data, "stats", stats)
	
	AudioManager.set_bus_volume(AudioManager.MASTER_BUS, options.master_volume)
	AudioManager.set_bus_volume(AudioManager.BGM_BUS, options.bgm_volume)
	AudioManager.set_bus_volume(AudioManager.SFX_BUS, options.sfx_volume)
	AudioManager.set_bus_volume(AudioManager.NARRATION_BUS, options.narration_volume)
	
	OS.window_fullscreen = options.fullscreen


func set_data(data, name, default_values):
	if not data.has(name):
		return
	
	#Update received data with missing default values
	for key in default_values.keys():
		if not data[name].has(key):
			data[name][key] = default_values[key]
			push_warning("Adding new profile entry '" + str(key) + str("' for " + str(name)))
		elif typeof(default_values[key]) == TYPE_DICTIONARY:
			set_data(data[name], key, default_values[key])
			
	for key in data[name].keys():
		#Ignore deprecated values
		if default_values.has(key):
			default_values[key] = data[name][key]
		else:
			data[name].erase(key)
			push_warning("Removing deprecated value '" + str(key) + str("' for " + str(name)))


func get_option(name):
	assert(options.has(name), "Not a valid option: " + str(name))
	return options[name]


func set_option(name: String, value, should_save := false):
	assert(options.has(name), "Not a valid option: " + str(name))
	options[name] = value
	if should_save:
		FileManager.save_profile()


func get_stat(name):
	assert(stats.has(name), "Not a valid stat: " + str(name))
	return stats[name]


func set_stat(name: String, value, should_save := false):
	assert(stats.has(name), "Not a valid stat: " + str(name))
	stats[name] = value
	if should_save:
		FileManager.save_profile()
