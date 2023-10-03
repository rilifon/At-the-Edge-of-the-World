extends Node2D


func _ready():
	FileManager.load_game()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")


