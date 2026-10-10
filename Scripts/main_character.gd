extends Node2D

@export var Grid: Node2D
@export var Hud: CanvasLayer
var rng = RandomNumberGenerator.new()

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
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Down":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Left":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("wall_hit")
	if GlobalVars.move_array[GlobalVars.move_step] == "Right":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("wall_hit")
	if MCOriginPoint_temp != Grid.MCOriginPoint_atlas:
		Grid.get_global_coords(Grid.MCOriginPoint_atlas)
		global_position = Grid.MCOriginPoint
		print("move")


func _on_area_2d_area_entered(area: Area2D) -> void:
	$AudioStreamPlayer2D.play()
	$Sprite2D.visible = false
	$Area2D.visible = false
	$DeathTimer.start()
	$LoseSound.play()
	#get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	if GlobalVars.move_step <= GlobalVars.move_array.size()-1:
		move()
		$MoveSound.play()
		$SoundTimer.start()
		GlobalVars.move_step = GlobalVars.move_step + 1
	else:
		#GlobalVars.coins = 0
		#get_tree().reload_current_scene()
		Hud.all_steps_finished()
		$AnimationPlayer.play("idle")
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
	pass
	#GlobalVars.total_attempts = 5
	#get_tree().reload_current_scene()


func _on_sound_timer_timeout() -> void:
	$MoveSound.stop()
	var my_random_number = rng.randf_range(1, 1.4)
	$MoveSound.pitch_scale = my_random_number


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Area2D/CollisionShape2D.disabled = true
	else:
		$Area2D/CollisionShape2D.disabled = false


func _on_lose_sound_finished() -> void:
	GlobalVars.coins = 0
	GlobalVars.move_step = 0
	GlobalVars.move_array.clear()
	if GlobalVars.current_level == 3:
		GlobalVars.total_attempts = 10
	else:
		GlobalVars.total_attempts = 5
	get_tree().reload_current_scene()
