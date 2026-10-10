extends CanvasLayer

@export var character_timer: Timer
@export var enemies: Node2D
var rng = RandomNumberGenerator.new()
var current_focus_vars: Array[String] = ["Master","Music","SFX"]
var current_focus: String
var master_index = AudioServer.get_bus_index("Master")
var music_index = AudioServer.get_bus_index("Music")
var sfx_index = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	$MP3Player/MusicOptions/Master/HScrollBarMaster.value = AudioServer.get_bus_volume_db(master_index)
	$MP3Player/MusicOptions/Music/HScrollBarMusic.value = AudioServer.get_bus_volume_db(music_index)
	$MP3Player/MusicOptions/SFX/HScrollBarSFX.value = AudioServer.get_bus_volume_db(sfx_index)
	current_focus = current_focus_vars[0]
	pass

func _process(_delta: float) -> void:
	$Notepad/Score/Number.text = str(GlobalVars.coins)
	$Notepad/Tries/Number.text = str(GlobalVars.total_attempts)

func add_move(direction) -> void:
	play_rundom_notepad(1)
	add_move_ui(direction)
	GlobalVars.move_array.append(direction)

func add_move_ui(direction) -> void:
	var new_child = HBoxContainer.new()
	$ScrollContainer/Commands.add_child(new_child)
	var new_label = Label.new()
	new_label.text = str(direction)
	new_child.add_child(new_label)
	var new_image = TextureRect.new()
	new_image.texture = load("res://Images/Arrows/" + direction + ".PNG")
	new_image.expand_mode = 2
	new_child.add_child(new_image)

func _on_clear_button_pressed() -> void:
	play_rundom_notepad(0)
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
		play_rundom_notepad(0)


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
	$Notepad/DeleteButton.disabled = true
	$Notepad/ClearButton.disabled = true
	$StartButton.disabled = true
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").start()

func all_steps_finished() -> void: 
	play_rundom_notepad(0)
	for n in $ScrollContainer/Commands.get_children():
		$ScrollContainer/Commands.remove_child(n)
	$Buttons/UpButton.disabled = false
	$Buttons/RightButton.disabled = false
	$Buttons/DownButton.disabled = false
	$Buttons/LeftButton.disabled = false
	$Notepad/DeleteButton.disabled = false
	$Notepad/ClearButton.disabled = false
	$StartButton.disabled = false
	character_timer.stop()
	for x in enemies.get_child_count():
		enemies.get_child(x).find_child("StepTimer").stop()


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("MP3move")
	else:
		$AnimationPlayer.play_backwards("MP3move")


func _on_button_up_pressed() -> void:
	$MP3Player/Sounds/DigitalUp.play()
	if current_focus == str(current_focus_vars[0]):
		current_focus = current_focus_vars[2]
		$MP3Player/SelectionBG/MasterFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/SFXFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[1]):
		current_focus = current_focus_vars[0]
		$MP3Player/SelectionBG/MusicFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/MasterFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[2]):
		current_focus = current_focus_vars[1]
		$MP3Player/SelectionBG/SFXFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/MusicFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_button_down_pressed() -> void:
	$MP3Player/Sounds/DigitalDown.play()
	if current_focus == str(current_focus_vars[0]):
		current_focus = current_focus_vars[1]
		$MP3Player/SelectionBG/MasterFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/MusicFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[1]):
		current_focus = current_focus_vars[2]
		$MP3Player/SelectionBG/MusicFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/SFXFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[2]):
		current_focus = current_focus_vars[0]
		$MP3Player/SelectionBG/SFXFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$MP3Player/SelectionBG/MasterFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)



func _on_button_left_pressed() -> void:
	$MP3Player/Sounds/DigitalLeft.play()
	if current_focus == str(current_focus_vars[0]):
		$MP3Player/MusicOptions/Master/HScrollBarMaster.value -= $MP3Player/MusicOptions/Master/HScrollBarMaster.step
	elif current_focus == str(current_focus_vars[1]):
		$MP3Player/MusicOptions/Music/HScrollBarMusic.value -= $MP3Player/MusicOptions/Music/HScrollBarMusic.step
	elif current_focus == str(current_focus_vars[2]):
		$MP3Player/MusicOptions/SFX/HScrollBarSFX.value -= $MP3Player/MusicOptions/SFX/HScrollBarSFX.step


func _on_button_right_pressed() -> void:
	$MP3Player/Sounds/DigitalRight.play()
	if current_focus == str(current_focus_vars[0]):
		$MP3Player/MusicOptions/Master/HScrollBarMaster.value += $MP3Player/MusicOptions/Master/HScrollBarMaster.step
	elif current_focus == str(current_focus_vars[1]):
		$MP3Player/MusicOptions/Music/HScrollBarMusic.value += $MP3Player/MusicOptions/Music/HScrollBarMusic.step
	elif current_focus == str(current_focus_vars[2]):
		$MP3Player/MusicOptions/SFX/HScrollBarSFX.value += $MP3Player/MusicOptions/SFX/HScrollBarSFX.step


func _on_h_scroll_bar_value_changed(value: float) -> void:
	if value == -30:
		AudioServer.set_bus_mute(master_index, true)
	else:
		AudioServer.set_bus_mute(master_index, false)
		AudioServer.set_bus_volume_db(master_index, value)


func _on_h_scroll_bar_music_value_changed(value: float) -> void:
	if value == -30:
		AudioServer.set_bus_mute(music_index, true)
	else:
		AudioServer.set_bus_mute(music_index, false)
		AudioServer.set_bus_volume_db(music_index, value)


func _on_h_scroll_bar_sfx_value_changed(value: float) -> void:
	if value == -30:
		AudioServer.set_bus_mute(sfx_index, true)
	else:
		AudioServer.set_bus_mute(sfx_index, false)
		AudioServer.set_bus_volume_db(sfx_index, value)

func play_rundom_notepad(value: bool) -> void:
	if value:
		$NotepadSounds.get_child(rng.randi_range(0, 3)).play()
	else:
		$NotepadSounds.get_child(rng.randi_range(4, 9)).play()
