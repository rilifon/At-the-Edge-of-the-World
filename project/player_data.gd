extends Node

signal update_resources

const ENUMS = {
	"rod_quality": ["RQ1", "RQ2", "RQ3", "RQ4", "RQ5", "RQ6", "RQ7", "RQ8", "RQ9", "RQ10"],
	"line_length": ["LL1", "LL2", "LL3", "LL4", "LL5", "LL6", "LL7", "LL8", "LL9", "LL10", "LL11",\
	 "LL12", "LL13", "LL14", "LL15", "LL16", "LL17", "LL18", "LL19", "LL20"]
}

var resources = {
	"money":{
		"name": "MONEY",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "MONEY_SUFFIX",
		"suffix_plural": "MONEY_SUFFIX_PLURAL",
		"showing": true
	},
	"money_engine":{
		"name": "MONEY_ENGINE",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "MONEY_ENGINE_SUFFIX",
		"suffix_plural": "MONEY_ENGINE_SUFFIX_PLURAL",
		"showing": false
	},
	"line_length":{
		"name": "LINE_LENGTH",
		"amount": 0,
		"max": 19,
		"gain_per_second": 0,
		"suffix": "enum",
		"suffix_plural": "enum",
		"showing": true
	},
	"rod_quality":{
		"name": "ROD_QUALITY",
		"amount": 0,
		"max": ENUMS.rod_quality.size() - 1,
		"gain_per_second": 0,
		"suffix": "enum",
		"suffix_plural": "enum",
		"showing": true
	},
	"auto_fish":{
		"name": "AUTO_FISH",
		"amount": 0,
		"max": 1,
		"gain_per_second": 0,
		"suffix": "naco",
		"suffix_plural": "",
		"showing": false
	},
}

func init():
	var first = true
	resources["bait"] = {}
	for bait in BaitManager.get_all_baits():
		resources[bait.id] = {"name": bait.bait_name, "amount": 0, "showing": false, "suffix": "unidade", "gain_per_second": 0}
		if first:
			first = false
			resources[bait.id].showing = true
	
	resources["loot"] = {}
	for loot in LootManager.get_all_loots():
		resources[loot.id] = {"name": loot.loot_name, "amount": 0, "showing": false, "image": loot.image, "gain_per_second": 0}

func update_resources():
	emit_signal("update_resources")

func get_resource_name(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name].name

func get_resource_amount(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name].amount

func get_resource_data(name):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	return resources[name]

func spend(name, amount):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].amount = max(resources[name].amount - amount, 0)
	update_resources()

func gain(name, amount, play_sfx := true):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].amount = resources[name].amount + amount
	if play_sfx and name == "money":
		AudioManager.play_sfx("getting_money")
	update_resources()

func increase_gain_per_second(name, amount):
	assert(resources.has(name), "Resource doesn't exist: " + str(name))
	resources[name].gain_per_second = resources[name].gain_per_second + amount
	update_resources()
