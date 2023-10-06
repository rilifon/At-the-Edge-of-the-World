extends Control


func _ready():
	Profile.set_stat("times_completed", Profile.get_stat("times_completed") + 1)
	Profile.set_stat("end1_done", true)
	
	if Global.USE_STEAM:
		Steam.set_achievement("ending_1")
	
	PaletteLayer.change_to(5)


func _input(event):
	if event.is_action_pressed("skip"):
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://MainMenu.tscn")
