extends Node

const LOOTS = [
	preload("res://loot/loot1.tres"),
	preload("res://loot/loot2.tres"),
	preload("res://loot/loot3.tres"),
	preload("res://loot/loot4.tres"),
	preload("res://loot/loot5.tres"),
	preload("res://loot/loot6.tres"),
	preload("res://loot/loot7.tres"),
	preload("res://loot/loot8.tres"),
	preload("res://loot/loot9.tres"),
	preload("res://loot/loot10.tres"),
]

func get_all_loots():
	return LOOTS

func get_loot_data(name):
	for loot in LOOTS:
		if loot.id == name:
			return loot
