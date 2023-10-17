extends Control

onready var AnimPlayer = $AnimationPlayer


func _ready():
	if Global.which_ending == 1:
		AnimPlayer.play("ending1")
	elif Global.which_ending == 2:
		AnimPlayer.play("ending2")
	else:
		push_error("Not a valid ending: " + str(Global.which_ending))

func start_narration(name):
	if name == "end1":
		NarrationManager.start_narration(NarrationDB.ENDING_1, NarrationDB.ENDING_1_PATH)
	elif name == "end2_1":
		NarrationManager.start_narration(NarrationDB.ENDING_2_1, NarrationDB.ENDING_2_PATH)
	elif name == "end2_2":
		NarrationManager.start_narration(NarrationDB.ENDING_2_2, NarrationDB.ENDING_2_PATH)
	else:
		push_error("Not a valid ending: " + str(Global.which_ending))
