extends CanvasLayer

@export var character_timer: Timer
@export var enemies: Node2D
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$AspectRatioContainer/VBoxContainer/Score/Number.text = str(GlobalVars.coins)
	$AspectRatioContainer/VBoxContainer/Tries/Number.text = str(GlobalVars.total_attempts)

func add_move(direction) -> void:
	add_move_ui(direction)
	GlobalVars.move_array.append(direction)

func add_move_ui(direction) -> void:
	var new_child = HBoxContainer.new()
	$ScrollContainer/Commands.add_child(new_child)
	var new_label = Label.new()
	new_label.text = str(direction)
	new_child.add_child(new_label)
	var new_image = TextureRect.new()
	new_image.texture = load("res://Images/TestImages/icon.svg")
	new_image.expand_mode = 2
	new_child.add_child(new_image)

func _on_clear_button_pressed() -> void:
	GlobalVars.move_step = 0
	GlobalVars.move_array.clear()
	for n in $ScrollContainer/Commands.get_children():
		$ScrollContainer/Commands.remove_child(n)



func _on_up_button_pressed() -> void:
	add_move("Up")
	$ButtonClick.volume_db = rng.randf_range(-6, 0)
	$ButtonClick.pitch_scale = rng.randf_range(0.8, 1.2)
	$ButtonClick.play()


func _on_right_button_pressed() -> void:
	add_move("Right")
	$ButtonClick.volume_db = rng.randf_range(-6, 0)
	$ButtonClick.pitch_scale = rng.randf_range(0.8, 1.2)
	$ButtonClick.play()


func _on_down_button_pressed() -> void:
	add_move("Down")
	$ButtonClick.volume_db = rng.randf_range(-6, 0)
	$ButtonClick.pitch_scale = rng.randf_range(0.8, 1.2)
	$ButtonClick.play()


func _on_left_button_pressed() -> void:
	add_move("Left")
	$ButtonClick.volume_db = rng.randf_range(-6, 0)
	$ButtonClick.pitch_scale = rng.randf_range(0.8, 1.2)
	$ButtonClick.play()


func _on_delete_button_pressed() -> void:
	if $ScrollContainer/Commands.get_child_count() != 0:
		$ScrollContainer/Commands.get_child($ScrollContainer/Commands.get_child_count()-1).queue_free()
		GlobalVars.move_array.remove_at(GlobalVars.move_array.size()-1)


func _on_stop_buttom_pressed() -> void:
	GlobalVars.move_step = 0
	GlobalVars.coins = 0
	GlobalVars.move_array.clear()
	get_tree().reload_current_scene()


func _on_start_button_pressed() -> void:
	$ButtonClick.volume_db = rng.randf_range(-6, 0)
	$ButtonClick.pitch_scale = rng.randf_range(0.8, 1.2)
	$ButtonClick.play()
	character_timer.start()
	$Buttons/UpButton.disabled = true
	$Buttons/RightButton.disabled = true
	$Buttons/DownButton.disabled = true
	$Buttons/LeftButton.disabled = true
	$GridContainer/HBoxContainer/DeleteButton.disabled = true
	$GridContainer/ClearButton.disabled = true
	$StartButton.disabled = true
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").start()

func all_steps_finished() -> void: 
	for n in $ScrollContainer/Commands.get_children():
		$ScrollContainer/Commands.remove_child(n)
	$Buttons/UpButton.disabled = false
	$Buttons/RightButton.disabled = false
	$Buttons/DownButton.disabled = false
	$Buttons/LeftButton.disabled = false
	$GridContainer/HBoxContainer/DeleteButton.disabled = false
	$GridContainer/ClearButton.disabled = false
	$StartButton.disabled = false
	character_timer.stop()
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").stop()
