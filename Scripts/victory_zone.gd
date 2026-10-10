extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if GlobalVars.current_level == 3:
		GlobalVars.win = 1
		var level = "res://Scenes/UI/MainMenu.tscn"
		get_tree().change_scene_to_file(level)
	elif GlobalVars.current_level == 1:
		GlobalVars.current_level = 2
		var level = "res://Scenes/PlayableLevels/Playable_2.tscn"
		get_tree().change_scene_to_file(level)
	elif GlobalVars.current_level == 3:
		GlobalVars.current_level = 2
		var level = "res://Scenes/PlayableLevels/Playable_3.tscn"
		get_tree().change_scene_to_file(level)
