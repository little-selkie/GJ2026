extends CanvasLayer

@export var character_timer: Timer
@export var enemies: Node2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$AspectRatioContainer/VBoxContainer/Score/Number.text = str(GlobalVars.coins)

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
	GlobalVars.move_array = []
	for n in $ScrollContainer/Commands.get_children():
		$ScrollContainer/Commands.remove_child(n)



func _on_up_button_pressed() -> void:
	add_move("Up")


func _on_right_button_pressed() -> void:
	add_move("Right")


func _on_down_button_pressed() -> void:
	add_move("Down")


func _on_left_button_pressed() -> void:
	add_move("Left")


func _on_delete_button_pressed() -> void:
	if $ScrollContainer/Commands.get_child_count() != 0:
		$ScrollContainer/Commands.get_child($ScrollContainer/Commands.get_child_count()-1).queue_free()
		GlobalVars.move_array.remove_at(GlobalVars.move_array.size()-1)


func _on_stop_buttom_pressed() -> void:
	GlobalVars.move_step = 0
	GlobalVars.coins = 0
	GlobalVars.move_array = []
	get_tree().reload_current_scene()


func _on_start_button_pressed() -> void:
	character_timer.start()
	$GridContainer/HBoxContainer/UpButton.disabled = true
	$GridContainer/HBoxContainer/RightButton.disabled = true
	$GridContainer/HBoxContainer/DownButton.disabled = true
	$GridContainer/HBoxContainer/LeftButton.disabled = true
	$GridContainer/HBoxContainer/DeleteButton.disabled = true
	$GridContainer/ClearButton.disabled = true
	$GridContainer/StartButton.disabled = true
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").start()

func all_steps_finished() -> void: 
	for n in $ScrollContainer/Commands.get_children():
		$ScrollContainer/Commands.remove_child(n)
	$GridContainer/HBoxContainer/UpButton.disabled = false
	$GridContainer/HBoxContainer/RightButton.disabled = false
	$GridContainer/HBoxContainer/DownButton.disabled = false
	$GridContainer/HBoxContainer/LeftButton.disabled = false
	$GridContainer/HBoxContainer/DeleteButton.disabled = false
	$GridContainer/ClearButton.disabled = false
	$GridContainer/StartButton.disabled = false
	character_timer.stop()
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").stop()
