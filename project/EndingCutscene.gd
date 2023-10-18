extends Control

const BGMS = {
	"end1": preload("res://assets/audio/bgm/end1.mp3"),
	"end": preload("res://assets/audio/bgm/end1.mp3"),
}
const CONSUME_SFXS = [
	["crunch1"],
	["crunch2", "crunch3"],
	["crunch4", "breaking1"],
	["breaking1", "crunch5", "breaking1"],
	["breaking2", "crunch5", "breaking2"],
	["breaking2", "crunch6", "crunch7", "breaking3"],
]
const GLITCH_VALUES = [
	[0.001,0.2,2,0],
	[0.002,0.2,5,0],
	[0.005,0.5,5,0.003],
	[0.01,0.5,6,0.005],
	[0.02,1.0,8,0.007],
	[0.03,1.0,8,0.01],
]
const CAM_SHAKES = [5,10,15,20,30,40]
const SHAKE_DECAY = 5.0

onready var AnimPlayer = $AnimationPlayer
onready var BGM = $BGM
onready var Kill = $Kill
onready var GlitchEffect = $GlitchEffect
onready var Cam = $Camera2D

var consume = 0
var cam_shake_strength = 0.0

func _ready():
	Profile.set_stat("times_completed", Profile.get_stat("times_completed") + 1)
	NarrationManager.is_running = false
	NarrationManager.stop_narration()
	
	yield(get_tree(), "idle_frame")
	
	reset_glitch_effects()
	Global.remove_distortion = true
	PaletteLayer.change_to(0)
	if Global.which_ending == 1:
		Profile.set_stat("end1_done", true)
		AnimPlayer.play("ending1")
	elif Global.which_ending == 2:
		Profile.set_stat("end2_done", true)
		AnimPlayer.play("ending2")
	else:
		push_error("Not a valid ending: " + str(Global.which_ending))
	BGM.play()


func _process(dt):
	if cam_shake_strength > 0.0:
		cam_shake_strength = lerp(cam_shake_strength, 0.0, SHAKE_DECAY*dt)
		
		Cam.offset = Vector2(rand_range(-cam_shake_strength, cam_shake_strength),\
							rand_range(-cam_shake_strength, cam_shake_strength))

func apply_cam_shake(strength):
	cam_shake_strength = strength


func start_narration(name):
	if name == "end1":
		NarrationManager.start_narration(NarrationDB.ENDING_1, NarrationDB.ENDING_1_PATH)
	elif name == "end2_1":
		NarrationManager.start_narration(NarrationDB.ENDING_2_1, NarrationDB.ENDING_2_PATH)
	elif name == "end2_2":
		NarrationManager.start_narration(NarrationDB.ENDING_2_2, NarrationDB.ENDING_2_PATH)
	else:
		push_error("Not a valid ending: " + str(Global.which_ending))


func end_narration():
	NarrationManager.remove_subtitle()


func reset_glitch_effects():
	apply_glitch_values(0, 0, 0, 0)


func apply_glitch_values(power, rate, speed, color_rate):
	GlitchEffect.material.set_shader_param("shake_power", power)
	GlitchEffect.material.set_shader_param("shake_rate", rate)
	GlitchEffect.material.set_shader_param("shake_speed", speed)
	GlitchEffect.material.set_shader_param("shake_color_rate", color_rate)


func finish():
	if Global.USE_STEAM:
		if Global.which_ending == 1:
			Steam.set_achievement("ending_1")
		elif Global.which_ending == 2:
			Steam.set_achievement("ending_2")
	
	NarrationManager.disable_effect()
# warning-ignore:return_value_discarded
	TransitionManager.change_scene("res://MainMenu.tscn")


func _on_Kill_acted(_self):
	Kill.disable_button()
	consume += 1
	if consume == 2 or consume == 3:
		Kill.set_text(tr("CONSUME2"))
	elif consume == 4:
		Kill.set_text(tr("CONSUME3"))
	elif consume == 5:
		Kill.set_text(tr("CONSUME4"))
	PaletteLayer.change_to(consume + 5)
	var data = GLITCH_VALUES[consume-1]
	apply_glitch_values(data[0], data[1], data[2], data[3])
	for sfx in CONSUME_SFXS[consume-1]:
		AudioManager.play_sfx(sfx, false, true)
		yield(get_tree().create_timer(.1), "timeout")
	apply_cam_shake(CAM_SHAKES[consume-1])
	if consume > 5:
		NarrationManager.enable_effect()
		apply_glitch_values(0.04,1.0,10,0.02)
		AnimPlayer.play("end1_final")
		return
	
	yield(get_tree().create_timer(.5 + .2*consume), "timeout")
	Kill.enable_button()
