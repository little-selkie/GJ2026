extends Node2D



func _on_track_1_finished() -> void:
	$Track2.start()

func _on_track_2_finished() -> void:
	$Track3.start()

func _on_track_3_finished() -> void:
	$Track4.start()

func _on_track_4_finished() -> void:
	$Track1.start()
