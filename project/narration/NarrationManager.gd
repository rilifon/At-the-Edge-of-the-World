extends CanvasLayer

signal finished_scrambling

const NARRATION_BUS = 3
const MIN_TIMER_RANGE = 1
const MAX_TIMER_RANGE = 1.1
const SCRAMBLE_DELAY = 1.0
const AHAB_DELAY = .75
const YOG_CUTOFF = 2.5
const YOG_DIST_CUTOFF = 1.5
const FADE_IN_SPEED = 6.0
const FADE_OUT_SPEED = 3.0
const NARRATIONS_PATH = "res://assets/audio/narration/dialogues/"
const SCRAMBLE_CYPHER = [
	"ä̫", "b̞̱̊͐", "c̈̀̇", "d́͗̃̂", "ẹ̀̌", "f̛̦", "g̉̇̃̏", "ḩ́̃̊̂", "ĭ̛̱̮̀̉̉", "j̨̋͛̆", "ķ̛̂̀", "ļ̤̂", "m̧̦̃̋̑",
	"n̮̦̱̊̋","ỏ̮̋", "ṕ̛̦̆̂", "q̉̌̂", "r̮̱̂̆", "ș̑̏", "ţ̤̦̉̂̃̈", "ự̃̊", "v̨", "ẇ̏", "x̨̱̦̃̊̀̇̆", "ỷ̛̀̊", "z̦̮̈",
]

onready var Player = $Player
onready var Subtitle = $Subtitle

var timer = 0.0
var cur_stage = 0
var seen_narrations
var is_running
var active_sub = false
var DB
var thread: Thread

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
		if active_sub:
			Subtitle.modulate.a = min(Subtitle.modulate.a + dt*FADE_IN_SPEED, 1.0)
		else:
			Subtitle.modulate.a = max(Subtitle.modulate.a - dt*FADE_OUT_SPEED, 0.0)
			if Subtitle.modulate.a <= 0.0:
				Subtitle.text = ""

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


func start_narration(narration, custom_path = false):
	for dialogue in narration:
		disable_effect()
		
		var path = NARRATIONS_PATH if not custom_path else custom_path
		path += dialogue.voice

		var dur = 0
		if dialogue.cha == "ahab":
			add_subtitle(tr(dialogue.text))
			dur = dur + AHAB_DELAY
		elif dialogue.cha == "yog":
			if not Global.remove_distortion:
				enable_effect()
				apply_scramble(tr(dialogue.text))
				yield(self, "finished_scrambling")
				dur = dur - YOG_DIST_CUTOFF
				if dialogue.has("dist_delay"):
					dur += dialogue.dist_delay
				path = path.replace(".wav", "_dist.wav")
			else:
				add_subtitle(tr(dialogue.text))
				dur = dur - YOG_CUTOFF
		
		Player.stream = load(path)
		dur += Player.stream.get_length()
		Player.play()
		
		yield(get_tree().create_timer(dur), "timeout")
		
	remove_subtitle()
	new_timer()


func add_subtitle(text):
	active_sub = true
	Subtitle.text = text


func remove_subtitle():
	active_sub = false


func apply_scramble(text):
	yield(get_tree(), "idle_frame")
	
	thread = Thread.new()

	var err = thread.start(self, "scramble_function", text)
	if err != OK:
		push_error("Failure when creating threads")
		add_subtitle(scramble_function(text))
		emit_signal("finished_scrambling")
		return

	
	while not thread.is_active():
		yield(get_tree(), "idle_frame")
	while thread.is_alive():
		yield(get_tree(), "idle_frame")
	
	add_subtitle(thread.wait_to_finish())
	emit_signal("finished_scrambling")


func scramble_function(text_to_dist):
	var text = ""
	for i in range(text_to_dist.length()):
		var c = text_to_dist[i]
		if c != " " and c != "," and c != "." and c != '"' and\
		   c != "'" and c != "!" and c != "?":
			text += SCRAMBLE_CYPHER[randi()%SCRAMBLE_CYPHER.size()]
		else:
			text += c
	return text
