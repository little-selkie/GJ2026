extends CanvasLayer

func _process(delta: float) -> void:
	$AspectRatioContainer/Score/Number.text = str(GlobalVars.coins)
