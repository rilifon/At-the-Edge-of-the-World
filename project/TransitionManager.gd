extends CanvasLayer

const ROT_RANGE = 10.0

onready var Effect = $Effect

var active = false


func _ready():
	randomize()
	Effect.material.set_shader_param("cutoff", 1.0)
	visible = false


func change_scene(scene_path):
	active = true
	visible = true
	AudioManager.play_sfx("wave_in")
	$AnimationPlayer.play_backwards("transition_out")
	yield($AnimationPlayer, "animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene(scene_path)
	yield(get_tree().create_timer(.2), "timeout")
	AudioManager.play_sfx("wave_out")
	$AnimationPlayer.play("transition_out")
	yield($AnimationPlayer, "animation_finished")
	visible = false
	active = false

