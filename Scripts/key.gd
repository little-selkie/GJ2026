extends Node2D

@export var coin_cost: int = 5
@export var Grid: Node2D

func _ready() -> void:
	$Label.text = str(coin_cost)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if GlobalVars.coins >= coin_cost:
		GlobalVars.coins = 0
		Grid.open_the_door()
		$Sprite2D.visible = false
		$Area2D.visible = false
		$AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
