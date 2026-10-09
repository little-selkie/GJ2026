extends Node2D

@export var Grid: Node2D
@export var Hud: CanvasLayer

func _ready() -> void:
	$Timer.wait_time = GlobalVars.time_step
	if Grid != null:
		global_position = Grid.MCOriginPoint
	else:
		queue_free()

func _process(_elta: float) -> void:
	pass

func move() -> void:
	var MCOriginPoint_temp: Vector2i = Grid.MCOriginPoint_atlas
	if GlobalVars.move_array[GlobalVars.move_step] == "Up":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y - 1)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y - 1)
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Down":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Left":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Right":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)
		else:
			$AnimationPlayer.play("wall_hit")
	if MCOriginPoint_temp != Grid.MCOriginPoint_atlas:
		Grid.get_global_coords(Grid.MCOriginPoint_atlas)
		global_position = Grid.MCOriginPoint
		print("move")


func _on_area_2d_area_entered(area: Area2D) -> void:
	$AudioStreamPlayer2D.play()
	$Sprite2D.visible = false
	$DeathTimer.start()
	GlobalVars.coins = 0
	GlobalVars.move_step = 0
	GlobalVars.move_array.clear()
	GlobalVars.total_attempts = 5
	#get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	if GlobalVars.move_step <= GlobalVars.move_array.size()-1:
		move()
		GlobalVars.move_step = GlobalVars.move_step + 1
	else:
		#GlobalVars.coins = 0
		#get_tree().reload_current_scene()
		Hud.all_steps_finished()
		GlobalVars.move_array.clear()
		GlobalVars.move_step = 0
		GlobalVars.total_attempts -= 1
	if GlobalVars.total_attempts == 0:
		get_tree().reload_current_scene()
		GlobalVars.total_attempts = 5
		GlobalVars.coins = 0
		GlobalVars.move_step = 0
		GlobalVars.move_array.clear()


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
