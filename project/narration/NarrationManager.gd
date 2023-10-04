extends Control

const NARRATION_BUS = 3
const MIN_TIMER_RANGE = 1
const MAX_TIMER_RANGE = 2
const AHAB_DELAY = .75
const YOG_CUTOFF = 2.5
const NARRATIONS_PATH = "res://assets/audio/narration/dialogues/"
const NarrationDB = preload("res://narration/NarrationDB.gd")

onready var Player = $Player
onready var Subtitle = $Subtitle

var timer = 0.0
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


func enable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, true)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 1, true)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 2, true)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 3, true)


func disable_effect():
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 0, false)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 1, false)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 2, false)
	AudioServer.set_bus_effect_enabled(NARRATION_BUS, 3, false)


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
			var new_idx = randi()%DB[i].size()
			while seen_narrations[i].has(new_idx):
				new_idx = randi()%DB[i].size()
			#Found an unseen narration
			seen_narrations[i].append(new_idx)
			start_narration(DB[i][new_idx])
			return
	#Not any new narrations, clearing the whole thing and starting over
	reset_seen_narrations()
	trigger_narration()


func start_narration(narration):
	for dialogue in narration:
		add_subtitle(tr(dialogue.text))
		Player.stream = load(NARRATIONS_PATH + dialogue.voice)
		
		var dur = Player.stream.get_length()
		if dialogue.cha == "ahab":
			disable_effect()
			dur = dur + AHAB_DELAY
		elif dialogue.cha == "yog":
			dur = dur - YOG_CUTOFF
			enable_effect()
		
		Player.play()
		yield(get_tree().create_timer(dur), "timeout")
		
	remove_subtitle()
	new_timer()


func add_subtitle(text):
	Subtitle.text = text

func remove_subtitle():
	Subtitle.text = ""
