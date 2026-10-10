extends Node2D

var rng = RandomNumberGenerator.new()
var current_focus_vars: Array[String] = ["Master","Music","SFX"]
var current_focus: String
var master_index = AudioServer.get_bus_index("Master")
var music_index = AudioServer.get_bus_index("Music")
var sfx_index = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	$Menu/AnimationParts/Whole.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Menu/VBoxContainer/Start.disabled = false
	$Menu/VBoxContainer/PowerOff.disabled = true
	current_focus = current_focus_vars[0]
	pass

func _draw() -> void:
	if GlobalVars.win != true:
		pass
	else:
		$Menu/VBoxContainer/Start.text = "Restart"
		$VictorySound.play()
		$Menu/WinLabel.visible = true
		GlobalVars.current_level = 1

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$HUD/AnimationPlayer.play("MP3move")
	else:
		$HUD/AnimationPlayer.play_backwards("MP3move")


func _on_h_scroll_bar_master_value_changed(value: float) -> void:
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


func _on_button_left_pressed() -> void:
	$HUD/MP3Player/Sounds/DigitalLeft.play()
	if current_focus == str(current_focus_vars[0]):
		$HUD/MP3Player/MusicOptions/Master/HScrollBarMaster.value -= $HUD/MP3Player/MusicOptions/Master/HScrollBarMaster.step
	elif current_focus == str(current_focus_vars[1]):
		$HUD/MP3Player/MusicOptions/Music/HScrollBarMusic.value -= $HUD/MP3Player/MusicOptions/Music/HScrollBarMusic.step
	elif current_focus == str(current_focus_vars[2]):
		$HUD/MP3Player/MusicOptions/SFX/HScrollBarSFX.value -= $HUD/MP3Player/MusicOptions/SFX/HScrollBarSFX.step


func _on_button_up_pressed() -> void:
	$HUD/MP3Player/Sounds/DigitalUp.play()
	if current_focus == str(current_focus_vars[0]):
		current_focus = current_focus_vars[2]
		$HUD/MP3Player/SelectionBG/MasterFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/SFXFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[1]):
		current_focus = current_focus_vars[0]
		$HUD/MP3Player/SelectionBG/MusicFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/MasterFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[2]):
		current_focus = current_focus_vars[1]
		$HUD/MP3Player/SelectionBG/SFXFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/MusicFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_button_right_pressed() -> void:
	$HUD/MP3Player/Sounds/DigitalRight.play()
	if current_focus == str(current_focus_vars[0]):
		$HUD/MP3Player/MusicOptions/Master/HScrollBarMaster.value += $HUD/MP3Player/MusicOptions/Master/HScrollBarMaster.step
	elif current_focus == str(current_focus_vars[1]):
		$HUD/MP3Player/MusicOptions/Music/HScrollBarMusic.value += $HUD/MP3Player/MusicOptions/Music/HScrollBarMusic.step
	elif current_focus == str(current_focus_vars[2]):
		$HUD/MP3Player/MusicOptions/SFX/HScrollBarSFX.value += $HUD/MP3Player/MusicOptions/SFX/HScrollBarSFX.step


func _on_button_down_pressed() -> void:
	$HUD/MP3Player/Sounds/DigitalDown.play()
	if current_focus == str(current_focus_vars[0]):
		current_focus = current_focus_vars[1]
		$HUD/MP3Player/SelectionBG/MasterFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/MusicFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[1]):
		current_focus = current_focus_vars[2]
		$HUD/MP3Player/SelectionBG/MusicFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/SFXFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	elif current_focus == str(current_focus_vars[2]):
		current_focus = current_focus_vars[0]
		$HUD/MP3Player/SelectionBG/SFXFocus.self_modulate = Color(0.0, 0.0, 0.0, 0.0)
		$HUD/MP3Player/SelectionBG/MasterFocus.self_modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_start_pressed() -> void:
	$AnimationPlayer.play("fade_to_level")
	$AudioStreamPlayer2D.play()


func _on_power_off_pressed() -> void:
	$AnimationPlayer.play("fade")
	$TurnOff.play()


func _on_down_button_pressed() -> void:
	$HUD/ButtonClick.play()
	if $Menu/VBoxContainer/Start.disabled:
		$Menu/VBoxContainer/Start.disabled = false
		$Menu/VBoxContainer/PowerOff.disabled = true
	else:
		$Menu/VBoxContainer/Start.disabled = true
		$Menu/VBoxContainer/PowerOff.disabled = false


func _on_up_button_pressed() -> void:
	$HUD/ButtonClick.play()
	if $Menu/VBoxContainer/Start.disabled:
		$Menu/VBoxContainer/Start.disabled = false
		$Menu/VBoxContainer/PowerOff.disabled = true
	else:
		$Menu/VBoxContainer/Start.disabled = true
		$Menu/VBoxContainer/PowerOff.disabled = false


func _on_start_button_pressed() -> void:
	$HUD/ButtonClick.play()
	$HUD/StartButton.disabled = true
	$HUD/Buttons/UpButton.disabled = true
	$HUD/Buttons/DownButton.disabled = true
	if $Menu/VBoxContainer/Start.disabled:
		$Menu/VBoxContainer/PowerOff.emit_signal("pressed")
	else:
		$Menu/VBoxContainer/Start.emit_signal("pressed")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		get_tree().quit()
	elif anim_name == "fade_to_level":
		GlobalVars.move_step = 0
		GlobalVars.coins = 0
		GlobalVars.move_array.clear()
		GlobalVars.win = 0
		if GlobalVars.current_level == 1:
			var level = "res://Scenes/PlayableLevels/Playable_1.tscn"
			get_tree().change_scene_to_file(level)


func _on_ambience_finished() -> void:
	$Ambience.play()
