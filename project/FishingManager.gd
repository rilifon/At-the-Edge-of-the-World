extends Node


func get_loot(bait, player_data):
	var bait_data = BaitManager.get_bait_data(bait)
	var loot_drops = []
	var total_weight = 0
	for loot in bait_data.loot_table:
		var loot_data = LootManager.get_loot_data(loot)
		if loot_data.minimum_length <= player_data.get_resource_amount("line_length"):
			loot_drops.append({"id": loot, "weight": loot_data.fishing_chance})
			total_weight += loot_data.fishing_chance
	assert(loot_drops.size() > 0, "Couldnt find any loot for this bait and line length: " + str(bait) + " " + str(player_data.get_resource_amount("line_length")))
	randomize()
	var chance = randi()%(total_weight + 1)
	for loot in loot_drops:
		total_weight -= loot.weight
		if total_weight <= chance:
			return loot.id
	#Maybe add a "unlucky didnt catch anything" mechanic? ψ('_')>
	assert(false, "Shouldn't get here")
	
