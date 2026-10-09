extends Node2D



func _on_track_1_finished() -> void:
	$Track2.play()

func _on_track_2_finished() -> void:
	$Track3.play()

func _on_track_3_finished() -> void:
	$Track4.play()

func _on_track_4_finished() -> void:
	$Track1.play()


func _on_level_start_finished() -> void:
	$Track1.play()
	$AnimationPlayer.play("ease_in")
