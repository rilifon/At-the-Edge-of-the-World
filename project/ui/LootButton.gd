extends Control

signal feed
signal sell

onready var loot_name = $MainContainer/Name
onready var image = $MainContainer/ContentContainer/ImageContainer/Image
onready var amount = $MainContainer/ContentContainer/ImageContainer/Amount
onready var price = $MainContainer/ContentContainer/ImageContainer/Price
onready var sell_buttons = $MainContainer/ContentContainer/Buttons/SellButtons
onready var feed_buttons = $MainContainer/ContentContainer/Buttons/FeedButtons

var amount_value = 0
var type

func setup(loot_id):
	type = loot_id
	var loot_data = LootManager.get_loot_data(loot_id)
	loot_name.text = loot_data.loot_name
	price.text = "$ %d $" % loot_data.base_cost
	image.texture = loot_data.image
	set_amount(0)
	yield(get_tree(), "idle_frame")
	rect_min_size = $MainContainer.rect_size


func set_amount(value):
	amount_value = value
	amount.text = "x%d" % value
	if value > 0:
		show()
	update_buttons_visibility()

func update_buttons_visibility():
	for i in sell_buttons.get_child_count():
		if amount_value >= pow(10, i):
			sell_buttons.get_child(i).show()
		else:
			sell_buttons.get_child(i).hide()
	for i in feed_buttons.get_child_count():
		if amount_value >= pow(10, i):
			feed_buttons.get_child(i).show()
		else:
			feed_buttons.get_child(i).hide()


func _on_feed_pressed(value):
	AudioManager.play_sfx("click_button")
	emit_signal("feed", type, value)


func _on_sell_pressed(value):
	AudioManager.play_sfx("click_button")
	emit_signal("sell", type, value)


func _on_button_mouse_entered(type_string, idx):
	var button
	if type_string == "feed":
		button = feed_buttons.get_child(idx)
	elif type_string == "sell":
		button = sell_buttons.get_child(idx)
	else:
		assert(false, "Not a valid type of button: " + str(type))
	button.mouse_entered()

func _on_button_mouse_exited(type_string, idx):
	var button
	if type_string == "feed":
		button = feed_buttons.get_child(idx)
	elif type_string == "sell":
		button = sell_buttons.get_child(idx)
	else:
		assert(false, "Not a valid type of button: " + str(type))
	button.mouse_exited()
