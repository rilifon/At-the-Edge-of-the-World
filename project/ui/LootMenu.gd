extends VBoxContainer

signal loot_sold(amount)
signal loot_nourished(amount)

onready var loot_label = $VBoxContainer/LootLabel
onready var price_label = $VBoxContainer/PriceLabel
onready var sell1 = $SellMenu/Sell1
onready var sell10 = $SellMenu/Sell10
onready var sell100 = $SellMenu/Sell100
onready var nourish1 = $NourishMenu/Nourish1
onready var nourish10 = $NourishMenu/Nourish10
onready var nourish100 = $NourishMenu/Nourish100


func set_loot(selected_loot):
	update_amount(selected_loot.amount)
	loot_label.text = selected_loot.loot_name
	price_label.text = "(%d %s)" % [selected_loot.cost, tr("MONEY_SUFFIX_PLURAL")]


func update_amount(amount: int):
	visible = amount > 0
	sell10.visible = amount > 9
	sell100.visible = amount > 99
	nourish10.visible = amount > 9
	nourish100.visible = amount > 99


func _on_sell_pressed(amount: int):
	emit_signal("loot_sold", amount)


func _on_nourish_pressed(amount: int):
	emit_signal("loot_nourished", amount)
