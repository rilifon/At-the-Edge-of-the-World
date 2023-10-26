extends CanvasLayer

const LOCALES = {
	"en": {
		"idx": 0,
	},
	"pt_BR": {
		"idx": 1,
	}
}

onready var SoundSettings = {
	"master": $VB/MasterSound,
	"bgm": $VB/BGMSound,
	"sfx": $VB/SFXSound,
	"narration": $VB/NarrationSound,
}
onready var Happiness = $VB/Happiness
onready var Fullscreen = $VB/Fullscreen
onready var AnimPlayer = $AnimationPlayer
onready var QuitButton = $ButtonsContainer/SaveQuit
onready var LanguageOptions = $VB/LanguageContainer/OptionButton

export var active = false
export var enable_quit := false


func _ready():
	hide()
	QuitButton.visible = enable_quit
	setup_languages()
	setup_values()


func enable():
	AnimPlayer.play("enable")


func disable():
	AnimPlayer.play("disable")


func setup_values():
	SoundSettings.master.set_value(Profile.get_option("master_volume")*100)
	SoundSettings.bgm.set_value(Profile.get_option("bgm_volume")*100)
	SoundSettings.sfx.set_value(Profile.get_option("sfx_volume")*100)
	SoundSettings.narration.set_value(Profile.get_option("narration_volume")*100)
	Happiness.set_value(Profile.get_option("happiness")*100)
	Fullscreen.pressed = OS.window_fullscreen


func setup_languages():
	LanguageOptions.add_item("English", 0)
	LanguageOptions.add_item("Português", 1)
	var locale = TranslationServer.get_locale()
	if LOCALES.has(locale):
		LanguageOptions.selected = LOCALES[locale].idx
	else:
		LanguageOptions.selected = 0


func save_values():
	Profile.set_option("master_volume", SoundSettings.master.get_value())
	Profile.set_option("bgm_volume", SoundSettings.bgm.get_value())
	Profile.set_option("sfx_volume", SoundSettings.sfx.get_value())
	Profile.set_option("narration_volume", SoundSettings.narration.get_value())
	Profile.set_option("happiness", Happiness.get_value())
	Profile.set_option("fullscreen", OS.window_fullscreen)
	FileManager.save_profile()


func _on_Sound_change_value(value, bus):
	AudioManager.set_bus_volume(bus, float(value)/100.0)


func _on_Back_acted(_self):
	disable()
	save_values()


func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_SaveQuit_acted(_self):
	AudioManager.play_sfx("click_button")
	save_values()
	FileManager.save_and_quit()


func _on_OptionButton_item_selected(index):
	for locale in LOCALES.keys():
		if LOCALES[locale].idx == index:
			Profile.set_option("locale", index)
			Profile.update_translation()
