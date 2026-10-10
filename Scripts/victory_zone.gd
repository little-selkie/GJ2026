extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if GlobalVars.current_level == 3:
		GlobalVars.total_attempts = 5
		GlobalVars.move_step = 0
		GlobalVars.coins = 0
		GlobalVars.move_array.clear()
		GlobalVars.win = 1
		var level = "res://Scenes/UI/MainMenu.tscn"
		get_tree().change_scene_to_file(level)
	elif GlobalVars.current_level == 1:
		GlobalVars.total_attempts = 5
		GlobalVars.move_step = 0
		GlobalVars.coins = 0
		GlobalVars.move_array.clear()
		GlobalVars.current_level = 2
		var level = "res://Scenes/PlayableLevels/Playable_2.tscn"
		get_tree().change_scene_to_file(level)
	elif GlobalVars.current_level == 2:
		GlobalVars.total_attempts = 10
		GlobalVars.move_step = 0
		GlobalVars.coins = 0
		GlobalVars.move_array.clear()
		GlobalVars.current_level = 3
		var level = "res://Scenes/PlayableLevels/Playable_3.tscn"
		get_tree().change_scene_to_file(level)
