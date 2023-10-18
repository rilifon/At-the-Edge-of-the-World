extends Node2D

const CONTAINER_SIZE = 400

onready var buttons = $Interface/ScrollContainer/Buttons
onready var upper_buttons = $UpperButtons
onready var resource_list = $Interface/ResourceList
onready var fera = $Fera
onready var Settings = $Settings
onready var ScrollCont = $Interface/ScrollContainer
onready var fishing_button = $UpperButtons/Fishing

var player_data

var cur_level = 0


func _ready():
	$NoBaitSelected.modulate.a = 0.0
	
	player_data = load("res://player_data.gd").new()
	player_data.init()
	
	player_data.connect("update_resources", resource_list , "update_resources")
	
	FileManager.set_current_run(self)
	if FileManager.continue_game:
		FileManager.continue_game = false
		FileManager.load_run()
	
	for button in buttons.get_children() + upper_buttons.get_children():
		button.setup(player_data, self)
		button.connect("acted", self, "_on_button_acted")
		button.update_cost_text()
		if button.level_unlocked > cur_level:
			button.hide()
		elif button.id == "buy_ending2" and not is_secret_ending_unlocked():
			button.hide()
		if button.reward_resource.type:
			var data = player_data.get_resource(button.reward_resource.type)
			if data and data.has("max") and data.max <= data.amount:
				button.maxed_out()
	
	resource_list.setup(player_data)
	resource_list.connect("feed", self, "_on_player_feed")
	resource_list.connect("sell", self, "_on_player_sell")
	
	fera.connect("leveled_up", self, "_on_level_up")
	
	resource_list.update_resources()
	
	PaletteLayer.change_to(cur_level)
	NarrationManager.set_cur_stage(cur_level)
	NarrationManager.is_running = true


func _input(event):
	if event.is_action_pressed("debug1"):
		player_data.gain("money", 9999999)
	elif event.is_action_pressed("debug2"):
		player_data.gain("money", 100)
	
	elif event.is_action_pressed("pause"):
		AudioManager.play_sfx("click_button")
		if Settings.active:
			Settings.disable()
		else:
			Settings.enable()


func _process(dt):
	for resource in player_data.resources:
		if resource.has("gain_per_second") and resource.gain_per_second > 0:
			player_data.gain(resource.id, resource.gain_per_second*dt, false)
	
	if player_data.get_resource_amount("auto_fish") and not fishing_button.on_cooldown:
		fishing_button.activate_button(true)


func get_selected_bait():
	return resource_list.get_selected_bait()


func get_save_data():
	var data = {
		"cur_level": cur_level,
		"player_data": player_data.get_save_data(),
		"narration_data": NarrationManager.get_data(),
		"beast_data": fera.get_data(),
		"buttons_data": get_buttons_data(),
		"remove_distortion": Global.remove_distortion,
	}
	return data


func get_buttons_data():
	var data = {}
	for button in buttons.get_children() + upper_buttons.get_children():
		data[button.id] = button.get_times_used()
	return data


func set_save_data(data):
	cur_level = data.cur_level
	player_data.set_save_data(data.player_data)
	NarrationManager.set_data(data.narration_data)
	Global.remove_distortion = data.remove_distortion
	fera.set_data(cur_level, data.beast_data)
	for button in buttons.get_children() + upper_buttons.get_children():
		button.set_times_used(data.buttons_data[button.id])


func is_secret_ending_unlocked():
	return false


func show_secret_ending_button():
	for button in upper_buttons:
		if button.id == "buy_ending2":
			button.show()


func _on_button_acted(button):
	if button.id == "fishing":
		AudioManager.play_sfx("fishing")
		var bait = resource_list.get_selected_bait()
		var loot = FishingManager.get_loot(bait, player_data)
		player_data.gain(loot, 1)
	elif button.id == "buy_ending":
# warning-ignore:return_value_discarded
		Global.which_ending = 1
		TransitionManager.change_scene("res://EndingCutscene.tscn")
	elif button.id == "buy_ending2":
# warning-ignore:return_value_discarded
		Global.which_ending = 2
		TransitionManager.change_scene("res://EndingCutscene.tscn")


func _on_Fishing_no_bait_selected():
	AudioManager.play_sfx("error_button")
	if $NoBaitSelected.modulate.a > 0:
		return
	$NoBaitSelected.modulate.a = 1.0
	yield(get_tree().create_timer(1.5), "timeout")
	$NoBaitSelected.modulate.a = 0.0


func _on_player_feed(loot, value):
	player_data.spend(loot, value)
	fera.feed(LootManager.get_loot_data(loot), value)


func _on_player_sell(loot, value):
	player_data.spend(loot, value)
	var loot_data = LootManager.get_loot_data(loot)
	player_data.gain("money", loot_data.base_cost*value)


func _on_level_up(level):
	cur_level = level
	NarrationManager.set_cur_stage(cur_level)
	for button in buttons.get_children() + upper_buttons.get_children():
		if button.level_unlocked <= cur_level:
			button.show()
		if button.id == "buy_ending2" and not is_secret_ending_unlocked():
			button.hide()
	PaletteLayer.change_to(cur_level)
	ScrollCont.rect_size.y = CONTAINER_SIZE


func _on_SettingsButton_pressed():
	Settings.enable()
	AudioManager.play_sfx("click_button")


func _on_SettingsButton_mouse_entered():
	AudioManager.play_sfx("hover_button")
