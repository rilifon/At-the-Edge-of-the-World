extends Control

const DELAY_TIME = .35

signal change_value

export var bus := 0
export var test_sfxs = []
export var dummy := false

onready var ValueLabel = $VBoxContainer/HBoxContainer/Label
onready var ValueSlider = $VBoxContainer/HBoxContainer/HSlider
onready var TestSFX = $TestSFX

var delay = 0.0

func _physics_process(delta):
	delay = max(delay - delta, 0.0)


func get_value():
	return ValueSlider.value/float(100)


func set_value(value):
	var was_dummy = dummy
	dummy = true
	ValueSlider.value = value
	ValueLabel.text = "%d" % [value]
	yield(get_tree(), "idle_frame")
	dummy = was_dummy


func _on_HSlider_value_changed(value):
	ValueLabel.text = "%d" % [value]
	
	if not dummy:
		emit_signal("change_value", value, bus)
		
		if not test_sfxs.empty() and not TestSFX.playing and delay <= 0.0:
			test_sfxs.shuffle()
			TestSFX.stream = test_sfxs.front()
			TestSFX.play()
			yield(TestSFX, "finished")
			delay = DELAY_TIME
