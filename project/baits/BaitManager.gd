extends Node

const BAITS = [
	preload("res://baits/bait1.tres"),
	preload("res://baits/bait2.tres"),
	preload("res://baits/bait3.tres"),
]

func get_all_baits():
	return BAITS

func get_bait_data(name):
	for bait in BAITS:
		if bait.id == name:
			return bait
