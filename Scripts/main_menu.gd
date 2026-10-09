extends CanvasLayer


func _on_start_button_pressed() -> void:
	var level = "res://Scenes/MAIN.tscn"
	get_tree().change_scene_to_file(level)


func _on_exit_button_button_down() -> void:
	get_tree().quit()
