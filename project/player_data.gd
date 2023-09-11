extends Node

signal update_resources

const ENUMS = {
	"rod_quality": ["Insalúbre", "Rubicunda", "Taciturna", "Kafkaesca", "Agnóstica", "Contatória", "Deletéria", "Idiossincrática", "Belicosa", "Iconoclasta"],
	"line_length": ["2 metros", "13 pés", "1968,5 polegadas", ".03 milhas", "varios decâmetros", "60 FPS", "duas mil 7belos alinhadas", "250 ampères", "7 gorilas pequenos", "7 gorilas medianos", "mais de um hectômetro", "200 megabytes", "uma porrada de espaguete", "2 maracanãs", "intestino grosso extendido", "amor de mãe", "semana útil-luz", "2 parsecs", "1 siriômetro", "grandão, tipo, pra caramba"]
}

var resources = {
	"money":{
		"name": "Grana",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "doleta",
		"showing": true
	},
	"money_engine":{
		"name": "Lacaios",
		"amount": 0,
		"gain_per_second": 0,
		"suffix": "ostra",
		"showing": false
	},
	"line_length":{
		"name": "Tamanho da Linha",
		"amount": 0,
		"max": 19,
		"gain_per_second": 0,
		"suffix": "enum",
		"showing": true
	},
	"rod_quality":{
		"name": "Qualidade da Vara",
		"amount": 0,
		"max": ENUMS.rod_quality.size() - 1,
		"gain_per_second": 0,
		"suffix": "enum",
		"showing": true
	},
	"auto_fish":{
		"name": "Molinete de Fusão a Frio",
		"amount": 0,
		"max": 1,
		"gain_per_second": 0,
		"suffix": "naco",
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
