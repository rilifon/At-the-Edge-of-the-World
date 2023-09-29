extends Control

onready var SoundSettings = [
	$VB/MasterSound,
	$VB/BGMSound,
	$VB/SFXSound,
	$VB/NarrationSound,
]

func _ready():
	setup_volumes()


func enable():
	show()


func disable():
	hide()


func setup_volumes():
	for setting in SoundSettings:
		setting.set_value(100) #TODO: Get right initial value


func _on_Sound_change_value(value, bus):
	AudioManager.set_bus_volume(bus, float(value)/100.0)


func _on_Back_acted(_self):
	disable()
