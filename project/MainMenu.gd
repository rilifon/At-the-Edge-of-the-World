extends Control

onready var animation = $AnimationPlayer
onready var progress_bar = $TextLayer/Skip/ProgressBar
onready var skip_box = $TextLayer/Skip

const SKIP_TOTAL_TIME = 1.0
const SKIP_REDUCTION_SPEED = 1


var skip_timer := 0.0


func _ready():
	pass


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


func skip():
	set_process(false)
	skip_box.hide()
	animation.seek(45.5, true)


func _on_Button_acted(_button):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScene.tscn")
