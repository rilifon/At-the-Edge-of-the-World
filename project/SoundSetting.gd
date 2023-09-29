extends Control

signal change_value

export var bus := 0

onready var ValueLabel = $VBoxContainer/HBoxContainer/Label
onready var ValueSlider = $VBoxContainer/HBoxContainer/HSlider


func set_value(value):
	ValueSlider.value = value


func _on_HSlider_value_changed(value):
	emit_signal("change_value", value, bus)
	ValueLabel.text = "%d" % [value]
