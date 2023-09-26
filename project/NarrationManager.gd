extends Node2D

const NARRATION_BUS = 3

onready var Player = $Player


func _ready():
	disable_effect()


func enable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, true)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 1, true)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 2, true)


func disable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, false)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 1, false)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 2, false)
