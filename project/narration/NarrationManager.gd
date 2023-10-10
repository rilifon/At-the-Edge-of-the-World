extends CanvasLayer

const NARRATION_BUS = 3
const MIN_TIMER_RANGE = 1
const MAX_TIMER_RANGE = 1.1
const SCRAMBLE_DELAY = 1.0
const AHAB_DELAY = .75
const YOG_CUTOFF = 2.5
const YOG_DIST_CUTOFF = 1.5
const NARRATIONS_PATH = "res://assets/audio/narration/dialogues/"
const NarrationDB = preload("res://narration/NarrationDB.gd")
const SCRAMBLE_CYPHER = [
	"a̵̢͖̠͔̲̺̫̦̅́͊̅̈̈́̔̇͛̈́̆̄̚̕͝","b̷̨̛̛̼̝͎̼̝͉͍̥̓́̽̔̌͐̿̑͘͜͠","c̷̠̀̌","d̷̨̪͖̺͇̗̣͉̻́̍͠͝","e̸̜̣̫͎̬̞͑̅͗̌̔̊͛͠","f̴̲̝͊́̚","g̷͍͙̮̜̞̰̲͉̫̲̩̔͗̑̚","h̶͙͚̺̯͎̼͎̘̖̱͚͖̙̫͂͑̓","ì̶̢͖̘̗̘̮̭̗̭̐̈́̑̋̂̈́̈͌̍͛̔̔̚͝","j̴̰̅͌̇̑","k̷̹͍̺͙̪͊̀͂̊̔́","l̶̙̖̳̯̫̀̈́͌̑͌̋͛̐̈́̓͘͝", "m̶̧͙̺͉̱̄͒̀̔̃͗̉̓̌̂͑͂̚͘͝",
	"n̶̰͐̒̾̆͋̓̓͝","ó̸̫͍̲̪̉̊͗̓̔̀͝","p̶̘̃̈͋͐̂̍͆̕","q̴̜͔̣̥͙̳̱̘̟̣͎̖̼̈́̓̾̅͆͐̐͋̾͋̔̓̑̒̊͜ͅ","r̶̡̦̰̦͂́̅̒̿͒̀̈́́̕̚͜","s̴̡͈̣͇̜̞̗͇͍̠̈́͜","t̴̯̥͌̎͆͆͂̀͑͛͒͗͒͘","u̸̡̥̝̫̰͖̙̰̗̻͒̈́̏̐̀̾̚͠͠","v̵̡̹̞̹̫͕͚͍͌̈̊͌̊̂̑̕","w̷͇͙̫̔̈́̄͐̅̈́́̔͑̀́̅͝͝͝","x̷̨̡̟̗̤̗̩͈̮̭̅ͅ","ỹ̴̛͉̞̑̍̽͜͝", "z̷̡̹̣͚̤̻̥̰̜͕̎̍̍̽̕͜",
]

onready var Player = $Player
onready var Subtitle = $Subtitle

var timer = 0.0
var scramble_timer = 0.0
var cur_stage = 0
var seen_narrations
var is_running
var DB

func _ready():
	DB = NarrationDB.DB
	Subtitle.text = ""
	reset_seen_narrations()
	new_timer()
	disable_effect()


func _process(dt):
	if is_running:
		if timer > 0.0:
			timer = max(timer - dt, 0.0)
			if timer <= 0.0:
				trigger_narration()


func get_data():
	return seen_narrations


func set_data(data):
	seen_narrations = data


func enable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, true)



func disable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, false)


func new_timer():
	timer = rand_range(MIN_TIMER_RANGE, MAX_TIMER_RANGE)


func reset_seen_narrations():
	seen_narrations = [
		[],[],[],[],[],
	]

func set_cur_stage(value):
	cur_stage = value


func trigger_narration():
	for i in range(cur_stage, -1, -1):
		if DB[i].size() > seen_narrations[i].size():
			#Still unseen narrations left
			var new_idx = 0#randi()%DB[i].size()
			while seen_narrations[i].has(new_idx):
				new_idx += 1#randi()%DB[i].size()
			#Found an unseen narration
			seen_narrations[i].append(new_idx)
			start_narration(DB[i][new_idx])
			return
	#Not any new narrations, clearing the whole thing and starting over
	reset_seen_narrations()
	trigger_narration()


func start_narration(narration):
	for dialogue in narration:
		disable_effect()
		
		add_subtitle(tr(dialogue.text))
		
		var path = NARRATIONS_PATH + dialogue.voice
		var dur = 0
		if dialogue.cha == "ahab":
			dur = dur + AHAB_DELAY
		elif dialogue.cha == "yog":
			if not Global.remove_distortion:
				enable_effect()
				apply_scramble()
				dur = dur - YOG_DIST_CUTOFF
				path = path.replace(".wav", "_dist.wav")
			else:
				dur = dur - YOG_CUTOFF
		
		Player.stream = load(path)
		dur += Player.stream.get_length()
		Player.play()
		
		yield(get_tree().create_timer(dur), "timeout")
		
	remove_subtitle()
	new_timer()


func add_subtitle(text):
	Subtitle.text = text


func remove_subtitle():
	Subtitle.text = ""


func apply_scramble():
	var text = ""
	for i in range(Subtitle.text.length()):
		var c = Subtitle.text[i]
		if c != " " and c != "," and c != ".":
			text += SCRAMBLE_CYPHER[randi()%SCRAMBLE_CYPHER.size()]
		else:
			text += c
	Subtitle.text = text
