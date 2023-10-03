extends Control

onready var SoundSettings = [
	$VB/MasterSound,
	$VB/BGMSound,
	$VB/SFXSound,
	$VB/NarrationSound,
]
onready var Dummy = $VB/Dummy
onready var Fullscreen = $VB/Fullscreen
onready var AnimPlayer = $AnimationPlayer

export var active = false

func _ready():
	setup_volumes()
	Dummy.set_value(100)
	Fullscreen.pressed = OS.window_fullscreen
	

func enable():
	AnimPlayer.play("enable")


func disable():
	AnimPlayer.play("disable")


func setup_volumes():
	for setting in SoundSettings:
		setting.set_value(100) #TODO: Get right initial value


func _on_Sound_change_value(value, bus):
	AudioManager.set_bus_volume(bus, float(value)/100.0)


func _on_Back_acted(_self):
	disable()


func _on_FullScreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
