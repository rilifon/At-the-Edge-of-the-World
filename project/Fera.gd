extends Control

signal leveled_up(level)

onready var bar = $VBoxContainer/Bar
onready var max_label = $VBoxContainer/Bar/MaxLabel
onready var special_1 = $HBoxContainer/Special1
onready var special_2 = $HBoxContainer/Special2

const MAX_LEVEL = 4
const MAX_VALUES = [40, 120, 250, 500, 1080]

var level := 0
var current_value := 0


func _ready():
	if level == MAX_LEVEL:
		bar.value = bar.max_value
		max_label.show()
	else:
		bar.value = current_value
		bar.max_value = MAX_VALUES[level]


func get_data():
	return bar.value


func set_data(new_level, value):
	level = new_level
	current_value = value
	bar.max_value = MAX_VALUES[level]
	bar.value = value
	if level == MAX_LEVEL:
		max_label.show()
		bar.value = bar.max_value
	

func feed(loot, amount):
	randomize()
	if randf() <= .5:
		AudioManager.play_sfx("chomp1")
	else:
		AudioManager.play_sfx("chomp2")
	current_value += loot.feed_value * amount
	if level < MAX_LEVEL:
		if current_value >= bar.max_value:
			level_up()
		else:
			bar.value = current_value


func level_up():
	AudioManager.play_sfx("level_up")
	if level == MAX_LEVEL:
		return
	
	level += 1
	
	if level == MAX_LEVEL:
		bar.value = bar.max_value
		max_label.show()
	else:
		current_value -= bar.max_value
		bar.max_value = MAX_VALUES[level]
		bar.value = current_value
	
	emit_signal("leveled_up", level)


func update_special_loot_visibility(special_loot):
	special_1.visible = special_loot[0].fed
	special_2.visible = special_loot[1].fed
