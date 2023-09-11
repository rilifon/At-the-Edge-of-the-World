extends Node2D

onready var buttons = $Interface/ScrollContainer/Buttons
onready var resource_list = $Interface/ResourceList
onready var fera = $Fera

var player_data

var cur_level = 0

func _input(event):
	#TODO: Remove this DEBUG
	if event.is_action_pressed("ui_home"):
		player_data.gain("money", 9999999)

func _ready():
	$NoBaitSelected.modulate.a = 0.0
	
	player_data = load("res://player_data.gd").new()
	player_data.init()
	
	player_data.connect("update_resources", resource_list , "update_resources")
	
	for button in buttons.get_children():
		button.setup(player_data, self)
		button.connect("acted", self, "_on_button_acted")
		if button.level_unlocked > cur_level:
			button.hide()
	
	resource_list.setup(player_data)
	resource_list.connect("feed", self, "_on_player_feed")
	resource_list.connect("sell", self, "_on_player_sell")
	
	fera.connect("leveled_up", self, "_on_level_up")


func _process(dt):
	for resource_id in player_data.resources:
		var resource = player_data.resources[resource_id]
		if resource.has("gain_per_second") and resource.gain_per_second > 0:
			player_data.gain(resource_id, resource.gain_per_second*dt, false)
	
	if player_data.get_resource_amount("auto_fish") and not $Interface/ScrollContainer/Buttons/Fishing.on_cooldown:
		$Interface/ScrollContainer/Buttons/Fishing.activate_button(true)

func get_selected_bait():
	return resource_list.get_selected_bait()


func _on_button_acted(button):
	if button.id == "fishing":
		AudioManager.play_sfx("fishing")
		var bait = resource_list.get_selected_bait()
		var loot = FishingManager.get_loot(bait, player_data)
		player_data.gain(loot, 1)
	elif button.id == "buy_ending":
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Ending.tscn")


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
	for button in buttons.get_children():
		if button.level_unlocked <= cur_level:
			button.show()
	PaletteLayer.change_to(cur_level)
