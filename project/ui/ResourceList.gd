extends Control

signal feed
signal sell

export(ButtonGroup) var loot_group: ButtonGroup

onready var scroll_container = $HBoxContainer/LootContainer/LootTable/ScrollContainer
onready var upper_gradient = $HBoxContainer/LootContainer/LootTable/UpperScrollGradient
onready var lower_gradient = $HBoxContainer/LootContainer/LootTable/LowerScrollGradient
onready var loot_container = $HBoxContainer/LootContainer/LootTable/ScrollContainer/GridContainer
onready var loot_menu = $HBoxContainer/LootContainer/LootMenu

const LABEL = preload("res://ui/ResourceLabel.tscn")
const BUTTON = preload("res://ui/ResourceButton.tscn")
const LOOT = preload("res://ui/LootSelect.tscn")
const BIG_FONT = preload("res://ui/BigFont.tres")

var upper_alpha: int
var lower_alpha: int
var max_scroll: int
var player = null
var selected_loot: Button


func _ready():
# warning-ignore:return_value_discarded
	loot_group.connect("pressed", self, "_on_loot_pressed")


func _process(_delta):
	max_scroll = loot_container.rect_size.y - scroll_container.rect_size.y
	upper_alpha = 0 if scroll_container.scroll_vertical == 0 else 1
	lower_alpha = 0 if scroll_container.scroll_vertical == max_scroll else 1
	upper_gradient.modulate.a = lerp(upper_gradient.modulate.a, upper_alpha, .3)
	lower_gradient.modulate.a = lerp(lower_gradient.modulate.a, lower_alpha, .3)


func setup(player_data):
	player = player_data
	
	var label = LABEL.instance()
	label.text = "STUFF"
	label.add_font_override("font", BIG_FONT)
	label.type = false
	$HBoxContainer/FirstList.add_child(label)
	var bait_mode = false
	var loot_mode = false
	for resource in player.resources:
		var resource_id = resource.id
		if resource_id == "buy_ending" or resource_id == "buy_ending2":
			continue
		if not loot_mode:
			if resource_id == "loot":
				loot_mode = true
				$HBoxContainer/LootContainer/LootLabel.type = false
			elif resource_id != "bait":
				if not bait_mode:
					var new_label = LABEL.instance()
					new_label.type = resource_id
					set_resource_text(new_label)
					$HBoxContainer/FirstList.add_child(new_label)
					if not resource.showing:
						new_label.hide()
				else:
					var new_button = BUTTON.instance()
					new_button.type = resource_id
					set_resource_text(new_button)
					new_button.pressed = false
					new_button.connect("pressed", self, "_on_button_pressed", [new_button])
					$HBoxContainer/FirstList.add_child(new_button)
					if not resource.showing:
						new_button.hide()
			else:
				bait_mode = true
				var new_label = LABEL.instance()
				new_label.text = "BAITS"
				new_label.add_font_override("font", BIG_FONT)
				new_label.type = false
				$HBoxContainer/FirstList.add_child(new_label)
		else:
			var new_loot = LOOT.instance()
			loot_container.add_child(new_loot)
			new_loot.setup(resource_id)
			new_loot.group = loot_group
			if not resource.showing:
				new_loot.hide()


func get_selected_bait():
	for button in $HBoxContainer/FirstList.get_children():
		if button is Button and button.pressed:
			return button.type
	return null


func update_resources():
	for resource in $HBoxContainer/FirstList.get_children():
		if resource.type:
			set_resource_text(resource)
	for resource in loot_container.get_children():
		if resource.type:
			update_loot_amount(resource)


func update_loot_amount(resource_object):
	var amount = player.get_resource(resource_object.type).amount
	resource_object.set_amount(amount)
	if selected_loot == resource_object:
		loot_menu.update_amount(amount)
		if amount > 0 and not selected_loot.pressed:
			selected_loot.set_pressed_no_signal(true)


func set_resource_text(resource_object):
	var resource = player.get_resource(resource_object.type)
	if resource.amount > 0:
		resource_object.show()
	if resource_object is Button:
		if resource.amount != 1:
			resource_object.text = " %s: %d %s" % [tr(resource.name), resource.amount, tr(resource.suffix_plural)]
		else:
			resource_object.text = " %s: %d %s" % [tr(resource.name), resource.amount, tr(resource.suffix)]
	elif resource_object is Label:
		if resource.suffix == "enum":
			resource_object.text = "%s: %s" % [tr(resource.name), tr(player.ENUMS[resource_object.type][resource.amount])]
		else:
			if resource.amount != 1:
				resource_object.text = "%s: %d %s" % [tr(resource.name), resource.amount, tr(resource.suffix_plural)]
			else:
				resource_object.text = "%s: %d %s" % [tr(resource.name), resource.amount, tr(resource.suffix)]
	if resource.gain_per_second > 0:
		resource_object.text += " (+%.2f/s)" % resource.gain_per_second


func _on_loot_feed(value):
	emit_signal("feed", selected_loot.type, value)


func _on_loot_sell(value):
	emit_signal("sell", selected_loot.type, value)


func _on_button_pressed(button):
	AudioManager.play_sfx("click_bait")
	for other_button in $HBoxContainer/FirstList.get_children():
		if other_button is Button and button != other_button:
			other_button.pressed = false


func _on_loot_pressed(button: Button):
	selected_loot = button
	loot_menu.set_loot(selected_loot)
	loot_menu.show()
