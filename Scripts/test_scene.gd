extends Node2D

func _process(_delta: float) -> void:
	$TestSprite.self_modulate = Color(1, 1, 1, DebugMenu.find_child("VisibilitySlider").value)
