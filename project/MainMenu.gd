extends Control

onready var animation = $AnimationPlayer
onready var NarrationSFX = $IntroNarration
onready var progress_bar = $TextLayer/Skip/ProgressBar
onready var skip_box = $TextLayer/Skip
onready var NewGame = $Menu/Buttons/NewGame
onready var SettingsButton = $Menu/Buttons/Settings
onready var Exit = $Menu/Buttons/Exit
onready var ContinueGame = $Menu/Buttons/ContinueGame
onready var ToggleDistorion = $Menu/Buttons/NewGame/ToggleDistortion
onready var Particle = $Menu/ParticlesEmitter
onready var Settings = $Settings

const SKIP_TOTAL_TIME = 1.0
const SKIP_REDUCTION_SPEED = 1


var skip_timer := 0.0


func _ready():
	randomize()
	PaletteLayer.change_to(0)
	Settings.hide()
	disable()
	ToggleDistorion.pressed = false
	ToggleDistorion.visible = Profile.get_stat("times_completed") > 0
	ContinueGame.visible = FileManager.run_file_exists()
	if Global.USE_STEAM:
		Global.USE_STEAM = Steam.is_init()
		print(Steam.is_init())

		print(Steam.utils.get_app_id())
		
		print(Steam.user.get_steam_id().convert_to_uint64())


func _process(delta):
	if Input.is_action_pressed("skip"):
		skip_timer += delta
	else:
		skip_timer -= SKIP_REDUCTION_SPEED * delta
		skip_timer = max(skip_timer, 0)
	
	progress_bar.value = progress_bar.max_value * skip_timer / SKIP_TOTAL_TIME
	if progress_bar.value >= progress_bar.max_value:
		skip()
	elif progress_bar.value > 0:
		skip_box.modulate.a = 1
	else:
		skip_box.modulate.a = lerp(skip_box.modulate.a, 0, .1)


func enable():
	NewGame.enable_button()
	Exit.enable_button()
	SettingsButton.enable_button()
	ContinueGame.enable_button()
	
	if Global.USE_STEAM:
		if Profile.get_stat("end1_done"):
			Steam.set_achievement("ending_1")
		if Profile.get_stat("end2_done"):
			Steam.set_achievement("ending_2")


func disable():
	NewGame.disable_button()
	Exit.disable_button()
	SettingsButton.disable_button()
	ContinueGame.disable_button()


func skip():
	set_process(false)
	NarrationSFX.stop()
	skip_box.hide()
	animation.seek(45.5, true)
	Particle.emitting = true
	enable()


func _on_NewGame_acted(_self):
	FileManager.continue_game = false
	FileManager.delete_run_file()
	Global.remove_distortion = ToggleDistorion.pressed
	# warning-ignore:return_value_discarded
	TransitionManager.change_scene("res://MainScene.tscn")


func _on_Exit_acted(_self):
	get_tree().quit()


func _on_Settings_acted(_self):
	Settings.enable()


func _on_ContinueGame_acted(_self):
	FileManager.continue_game = true
	# warning-ignore:return_value_discarded
	TransitionManager.change_scene("res://MainScene.tscn")


func _on_ToggleDistortion_toggled(button_pressed):
	if button_pressed:
		AudioManager.play_sfx("toggle_dist_off")
	else:
		AudioManager.play_sfx("toggle_dist_on")
