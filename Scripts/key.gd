extends Node2D

@export var coin_cost: int = 5
@export var Grid: Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if GlobalVars.coins == coin_cost:
		GlobalVars.coins = 0
		Grid.open_the_door()
		queue_free()
