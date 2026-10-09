extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var my_random_number = rng.randf_range(0, 1)
	$AnimationPlayer.play_section("coin_animation", my_random_number)

func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVars.coins += 1
	var my_random_number = rng.randf_range(1, 1.4)
	$AudioStreamPlayer2D.pitch_scale = my_random_number
	$AudioStreamPlayer2D.play()
	$Timer.start()


func _on_timer_timeout() -> void:
	queue_free()
