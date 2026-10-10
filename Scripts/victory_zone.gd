extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVars.win = 1
	var level = "res://Scenes/UI/MainMenu.tscn"
	get_tree().change_scene_to_file(level)
