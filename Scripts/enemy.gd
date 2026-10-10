extends Node2D

@export var Grid: Node2D
@export_flags("Up", "Right", "Down", "Left") var movement_pattern: Array[int]
var current_step = 1
var direction = 0
var enemy_atlas_position: Vector2i
var reverce_movement_pattern: Array[int]
var forward_movement_pattern: Array[int]
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var my_random_number = rng.randi_range(1, 4)
	if my_random_number == 1:
		$Sprite2D.texture = load("res://Images/Props/EnemyBlue.png")
	elif my_random_number == 2:
		$Sprite2D.texture = load("res://Images/Props/EnemyOrange.png")
	elif my_random_number == 3:
		$Sprite2D.texture = load("res://Images/Props/EnemyRed.png")
	elif my_random_number == 4:
		$Sprite2D.texture = load("res://Images/Props/EnemyBlue.png")
		$Sprite2D.self_modulate = Color(1.0, 0.204, 1.0)
	forward_movement_pattern = movement_pattern
	for x in movement_pattern.size():
		if movement_pattern[x] == 1:
			reverce_movement_pattern.append(4)
		if movement_pattern[x] == 2:
			reverce_movement_pattern.append(8)
		if movement_pattern[x] == 4:
			reverce_movement_pattern.append(1)
		if movement_pattern[x] == 8:
			reverce_movement_pattern.append(2)
	if movement_pattern[current_step-1] == 1:
			$DirectionLabel.text = str("Up")
	if movement_pattern[current_step-1] == 2:
			$DirectionLabel.text = str("Right")
	if movement_pattern[current_step-1] == 4:
			$DirectionLabel.text = str("Down")
	if movement_pattern[current_step-1] == 8:
			$DirectionLabel.text = str("Left")
	
	$StepTimer.wait_time = GlobalVars.time_step
	current_step = 1
	if Grid != null:
		var coordinates_array = Grid.place_enemies()
		var coordinates = coordinates_array[0]
		enemy_atlas_position = coordinates_array[1]
		if coordinates == Vector2(0,0):
			queue_free()
		else:
			global_position = coordinates
	else:
		queue_free()

func move() -> void:
	travel()
	print("forward")
	current_step += 1
	if current_step > movement_pattern.size():
		current_step -= 1
		direction = 1
		movement_pattern = reverce_movement_pattern

func move_back() -> void:
	travel()
	print("back")
	current_step -= 1
	if current_step == 0:
		current_step = 1
		direction = 0
		movement_pattern = forward_movement_pattern

func _on_step_timer_timeout() -> void:
	if movement_pattern.size() != 0:
		if direction == 0:
			move()
		elif direction == 1:
			move_back()

func move_up() -> void:
	global_position = Grid.enemy_move_to(Vector2i(enemy_atlas_position.x, enemy_atlas_position.y-1))
	enemy_atlas_position = Vector2i(enemy_atlas_position.x, enemy_atlas_position.y-1)

func move_right() -> void:
	global_position = Grid.enemy_move_to(Vector2i(enemy_atlas_position.x+1, enemy_atlas_position.y))
	enemy_atlas_position = Vector2i(enemy_atlas_position.x+1, enemy_atlas_position.y)

func move_down() -> void:
	global_position = Grid.enemy_move_to(Vector2i(enemy_atlas_position.x, enemy_atlas_position.y+1))
	enemy_atlas_position = Vector2i(enemy_atlas_position.x, enemy_atlas_position.y+1)

func move_left() -> void:
	global_position = Grid.enemy_move_to(Vector2i(enemy_atlas_position.x-1, enemy_atlas_position.y))
	enemy_atlas_position = Vector2i(enemy_atlas_position.x-1, enemy_atlas_position.y)

func travel() -> void:
	if current_step > movement_pattern.size():
		pass
	else:
		if movement_pattern[current_step-1] == 1:
			move_up()
		elif movement_pattern[current_step-1] == 2:
			move_right()
		elif movement_pattern[current_step-1] == 4:
			move_down()
		elif movement_pattern[current_step-1] == 8:
			move_left()

#func pattern_to_text() -> void:
		#if movement_pattern[current_step] == 1:
			#$DirectionLabel.text = str("Up")
		#if movement_pattern[current_step] == 2:
			#$DirectionLabel.text = str("Right")
		#if movement_pattern[current_step] == 4:
			#$DirectionLabel.text = str("Down")
		#if movement_pattern[current_step] == 8:
			#$DirectionLabel.text = str("Left")
