extends Node2D


func _ready():
	FileManager.load_game()
	PaletteLayer.change_to(0)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")


