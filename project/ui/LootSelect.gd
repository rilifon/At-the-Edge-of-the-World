extends Button

onready var amount_label = $Amount
onready var loot_icon = $Icon

var amount := 0
var type
var loot_name
var cost


func setup(loot_id):
	var loot_data = LootManager.get_loot_data(loot_id)
	type = loot_id
	loot_name = loot_data.loot_name
	cost = loot_data.base_cost
	$Icon.texture = loot_data.image
	set_amount(0)


func set_amount(value):
	amount = value
	amount_label.text = String(amount)
	if amount > 0:
		self_modulate = Color.white
		loot_icon.modulate = Color.white
		disabled = false
		show()
	else:
		self_modulate = Color(1, 1, 1, .2)
		loot_icon.modulate = Color(1, 1, 1, .2)
		disabled = true
		set_pressed_no_signal(false)


func _on_Button_pressed():
	AudioManager.play_sfx("click_button")


func _on_Button_mouse_entered():
	AudioManager.play_sfx("hover_button")


func _on_Button_mouse_exited():
	AudioManager.play_sfx("hover_button")
