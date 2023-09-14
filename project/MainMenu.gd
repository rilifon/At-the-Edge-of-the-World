extends Control

onready var animation = $AnimationPlayer
onready var progress_bar = $TextLayer/Skip/ProgressBar
onready var skip_box = $TextLayer/Skip
onready var NewGame = $Menu/VBoxContainer/NewGame
onready var Exit = $Menu/VBoxContainer/NewGame

const SKIP_TOTAL_TIME = 1.0
const SKIP_REDUCTION_SPEED = 1


var skip_timer := 0.0


func _ready():
	disable()
	if Global.USE_STEAM:
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


func disable():
	NewGame.disable_button()
	Exit.disable_button()


func skip():
	set_process(false)
	skip_box.hide()
	animation.seek(45.5, true)


func _on_NewGame_acted(_self):
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScene.tscn")


func _on_Exit_acted(_self):
	get_tree().quit()
