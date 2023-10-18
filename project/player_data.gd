extends Node

signal update_resources

const ENUMS = {
	"rod_quality": ["RQ1", "RQ2", "RQ3", "RQ4", "RQ5", "RQ6", "RQ7", "RQ8", "RQ9", "RQ10"],
	"line_length": ["LL1", "LL2", "LL3", "LL4", "LL5", "LL6", "LL7", "LL8", "LL9", "LL10", "LL11",\
	 "LL12", "LL13", "LL14", "LL15", "LL16", "LL17", "LL18", "LL19", "LL20"]
}

var resources = [
	{
		"id": "money",
		"name": "MONEY",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "MONEY_SUFFIX",
		"suffix_plural": "MONEY_SUFFIX_PLURAL",
		"showing": true
	},
	{
		"id": "money_engine",
		"name": "MONEY_ENGINE",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "MONEY_ENGINE_SUFFIX",
		"suffix_plural": "MONEY_ENGINE_SUFFIX_PLURAL",
		"showing": false
	},
	{
		"id": "line_length",
		"name": "LINE_LENGTH",
		"amount": 0,
		"max": ENUMS.line_length.size() - 1,
		"gain_per_second": 0,
		"suffix": "enum",
		"suffix_plural": "enum",
		"showing": true
	},
	{
		"id": "rod_quality",
		"name": "ROD_QUALITY",
		"amount": 0,
		"max": ENUMS.rod_quality.size() - 1,
		"gain_per_second": 0,
		"suffix": "enum",
		"suffix_plural": "enum",
		"showing": true
	},
	{
		"id": "auto_fish",
		"name": "AUTO_FISH",
		"amount": 0,
		"max": 1,
		"gain_per_second": 0,
		"suffix": "AUTO_FISH_SUFFIX",
		"suffix_plural": "AUTO_FISH_SUFFIX_PLURAL",
		"showing": false
	},
	{
		"id": "buy_ending",
		"name": "",
		"amount": 0,
		"gain_per_second": 0,
		"showing": false
	},
	{
		"id": "buy_ending2",
		"name": "",
		"amount": 0,
		"gain_per_second": 0,
		"showing": false
	},
]

func init():
	var first = true
	#This is disgusting and I hate it
	resources.append({"id": "bait"})
	for bait in BaitManager.get_all_baits():
		var data = {"id": bait.id, "name": bait.bait_name, "amount": 0, "showing": false, "suffix": "BAIT_SUFFIX", "suffix_plural": "BAIT_SUFFIX_PLURAL", "gain_per_second": 0}
		resources.append(data)
		if first:
			first = false
			data.showing = true
	#aaaaa why did we do this
	resources.append({"id": "loot"})
	for loot in LootManager.get_all_loots():
		var data = {"id":loot.id, "name": loot.loot_name, "amount": 0, "showing": false, "image": loot.image, "gain_per_second": 0}
		resources.append(data)


func get_save_data():
	var data = resources.duplicate(true)
	return data


func set_save_data(data):
	resources = data


func update_resources():
	emit_signal("update_resources")


func get_resource(id):
	for resource in resources:
		if resource.id == id:
			return resource
	push_error("Couldn't find this resource: " + str(id))


func get_resource_name(id):
	return get_resource(id).name


func get_resource_amount(id):
	return get_resource(id).amount


func spend(id, amount):
	var res = get_resource(id)
	res.amount = max(res.amount - amount, 0)
	update_resources()


func gain(id, amount, play_sfx := true):
	var res = get_resource(id)
	res.amount = res.amount + amount
	if play_sfx and name == "money":
		AudioManager.play_sfx("getting_money")
	update_resources()


func increase_gain_per_second(id, amount):
	var res = get_resource(id)
	res.gain_per_second = res.gain_per_second + amount
	update_resources()
