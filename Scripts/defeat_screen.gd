extends CanvasLayer


func _on_try_again_button_button_down() -> void:
	var level = "res://Scenes/UI/MainMenu.tscn"
	get_tree().change_scene_to_file(level)


func _on_exit_button_button_down() -> void:
	get_tree().quit()
