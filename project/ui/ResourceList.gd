extends Control

signal feed
signal sell

const LABEL = preload("res://ui/ResourceLabel.tscn")
const BUTTON = preload("res://ui/ResourceButton.tscn")
const LOOT = preload("res://ui/LootButton.tscn")
const BIG_FONT = preload("res://ui/BigFont.tres")

var player = null

func setup(player_data):
	player = player_data
	
	var label = LABEL.instance()
	label.text = "--MUAMBAS--"
	label.add_font_override("font", BIG_FONT)
	label.type = false
	$HBoxContainer/FirstList.add_child(label)
	var bait_mode = false
	var loot_mode = false
	for resource_id in player.resources:
		if not loot_mode:
			if resource_id == "loot":
				loot_mode = true
				var new_label = LABEL.instance()
				new_label.text = "--PESCADOS--"
				new_label.add_font_override("font", BIG_FONT)
				new_label.type = false
				$HBoxContainer/ScrollContainer/LootList.add_child(new_label)
				
			elif resource_id != "bait":
				var resource = player.resources[resource_id]
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
				new_label.text = "--ISCAS--"
				new_label.add_font_override("font", BIG_FONT)
				new_label.type = false
				$HBoxContainer/FirstList.add_child(new_label)
		else:
			var resource = player.resources[resource_id]
			var new_loot = LOOT.instance()
			$HBoxContainer/ScrollContainer/LootList.add_child(new_loot)
			new_loot.setup(resource_id)
			new_loot.connect("feed", self, "_on_loot_feed")
			new_loot.connect("sell", self, "_on_loot_sell")
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
	for resource in $HBoxContainer/ScrollContainer/LootList.get_children():
		if resource.type:
			update_loot_amount(resource)

func update_loot_amount(resource_object):
	var resource = player.resources[resource_object.type]
	resource_object.set_amount(resource.amount)

func set_resource_text(resource_object):
	var resource = player.resources[resource_object.type]
	if resource.amount > 0:
		resource_object.show()
	if resource_object is Button:
		resource_object.text = "                 %s: %d %s" % [resource.name, resource.amount, resource.suffix]
		if resource.amount != 1:
			resource_object.text += "s"
	elif resource_object is Label:
		if resource.suffix == "enum":
			resource_object.text = "%s: %s" % [resource.name, player.ENUMS[resource_object.type][resource.amount]]
		else:
			resource_object.text = "%s: %d %s" % [resource.name, resource.amount, resource.suffix]
			if resource.amount != 1:
				resource_object.text += "s"
	if resource.gain_per_second > 0:
		resource_object.text += " (+%.2f/s)" % resource.gain_per_second


func _on_loot_feed(loot, value):
	emit_signal("feed", loot, value)


func _on_loot_sell(loot, value):
	emit_signal("sell", loot, value)

func _on_button_pressed(button):
	AudioManager.play_sfx("click_bait")
	for other_button in $HBoxContainer/FirstList.get_children():
		if other_button is Button and button != other_button:
			other_button.pressed = false
