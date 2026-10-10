
extends CanvasLayer

# ------------------------------------------------------------
# TIMER SETTINGS
# ------------------------------------------------------------

@export_range(1.0, 600.0, 0.1)
var min_glitch_interval: float = 30.0

@export_range(1.0, 600.0, 0.1)
var max_glitch_interval: float = 90.0


# ------------------------------------------------------------
# SOUNDS
# ------------------------------------------------------------

@export var glitch_sound: AudioStream
@export var fix_sound: AudioStream


# ------------------------------------------------------------
# REFS AND VARS
# ------------------------------------------------------------

@onready var crt_filter: ColorRect = $CRT_Filter_Final

var shader_material: ShaderMaterial
var glitch_timer: Timer

var glitch_audio_player: AudioStreamPlayer
var fix_audio_player: AudioStreamPlayer

var rng := RandomNumberGenerator.new()
var is_glitched: bool = false


# ------------------------------------------------------------
# DEFAULT SETTINGS
# CRT geometry (curvature and corner_radius) use material settings.
# ------------------------------------------------------------

const DEFAULT_SETTINGS: Dictionary = {
	"border_color": Color(0.0, 0.0, 0.0, 1.0),

	"scanlines": 0.35,
	"scanline_size": 3.0,

	"vignette": 0.35,
	"brightness": 1.1,
	"rgb_mask": false,
	"mask_strength": 0.3,

	"scanlines_1": 500.0,
	"scanlines_2": 25.0,
	"scan_reduction": 0.1,

	"animated_scan_speed_1": 1.0,
	"animated_scan_speed_2": 0.4,

	"noise_strength": 0.04,
	"noise_speed": 12.0,

	"radial_vignette_alpha": 0.2,
	"radial_vignette_inner_radius": 0.0,
	"radial_vignette_outer_radius": 1.0,

	"glitch_flicker_strength": 0.0,
	"scanline_noise_strength": 0.0,
	"interference_strength": 0.0,
	
	"glitch_dropout_strength": 0.0,
	
	"glitch_active": false,
	"animated_scanline_thickness_1": 0.35,
	"animated_scanline_thickness_2": 0.25,
	
}


# ------------------------------------------------------------
# INIT
# ------------------------------------------------------------

func _ready() -> void:
	rng.randomize()

	# ShaderMaterial from ColorRect
	var original_material := crt_filter.material as ShaderMaterial

	if original_material == null:
		push_error(
            "CRT_Filter_Final has no ShaderMaterial!"
		)
		return

	# Copy material
	shader_material = original_material.duplicate() as ShaderMaterial

	if shader_material == null:
		push_error("Can't copy ShaderMaterial!")
		return

	crt_filter.material = shader_material

	# Fullscreen ColorRect ingnore mouse
	crt_filter.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Creating audio players
	_create_audio_players()

	# Creating a new timer
	glitch_timer = Timer.new()
	glitch_timer.name = "GlitchTimer"
	glitch_timer.one_shot = true
	add_child(glitch_timer)

	glitch_timer.timeout.connect(_on_glitch_timer_timeout)

	# Set default picture settings on start
	_apply_default_settings()

	# Activate timer before next glitch
	_schedule_next_glitch()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("trigger_crt_glitch"):
		
		if is_glitched:
			return
		
		if glitch_timer != null:
			glitch_timer.stop()
		
	_trigger_glitch()


# ------------------------------------------------------------
# AUDIO PLAYERS CREATION
# ------------------------------------------------------------

func _create_audio_players() -> void:
	if glitch_sound != null:
		glitch_audio_player = AudioStreamPlayer.new()
		glitch_audio_player.name = "GlitchSoundPlayer"
		glitch_audio_player.stream = glitch_sound
		glitch_audio_player.bus = "SFX"
		add_child(glitch_audio_player)

	if fix_sound != null:
		fix_audio_player = AudioStreamPlayer.new()
		fix_audio_player.name = "FixSoundPlayer"
		fix_audio_player.stream = fix_sound
		fix_audio_player.bus = "SFX"
		add_child(fix_audio_player)


# ------------------------------------------------------------
# NEXT GLITCH TIMER
# ------------------------------------------------------------

func _schedule_next_glitch() -> void:
	if glitch_timer == null:
		return

	var minimum := maxf(min_glitch_interval, 30.1)
	var maximum := maxf(max_glitch_interval, minimum)

	var wait_time := rng.randf_range(minimum, maximum)

	glitch_timer.start(wait_time)


func _on_glitch_timer_timeout() -> void:
	# Don't glitch again if glitched already
	if is_glitched:
		return

	_trigger_glitch()


# ------------------------------------------------------------
# CRT GLITCH
# ------------------------------------------------------------

func _trigger_glitch() -> void:
	is_glitched = true

	# Random frame color: red, green, blue, purple
	var border_palette: Array[Color] = [
		Color(0.8, 0.03, 0.03, 1.0),
		Color(0.03, 0.7, 0.08, 1.0),
		Color(0.03, 0.1, 0.8, 1.0),
		Color(0.7, 0.03, 0.6, 1.0)
	]

	var glitch_border: Color = border_palette[
		rng.randi_range(0, border_palette.size() - 1)
	]

	# Strong sudden glitch
	
	
	var glitch_settings: Dictionary = {
			"glitch_active": true,
			"border_color": glitch_border,
		
			"scanlines": rng.randf_range(0.9, 1.0),
			"scanline_size": rng.randf_range(6.0, 8.0),
		
			"vignette": rng.randf_range(0.7, 0.9),
		
			"brightness": rng.randf_range(1.1, 1.35),
		
			"rgb_mask": true,
			"mask_strength": rng.randf_range(0.65, 0.85),
		
			"scanlines_1": rng.randf_range(350.0, 500.0),
			"scanlines_2": rng.randf_range(35.0, 55.0),
			#"scanlines_1": rng.randf_range(750.0, 1000.0),
			#"scanlines_2": rng.randf_range(60.0, 120.0),
			"scan_reduction": rng.randf_range(0.2, 0.3),
		
			"animated_scan_speed_1": rng.randf_range(0.001, 0.003),
			"animated_scan_speed_2": rng.randf_range(0.004, 0.01),
		
			"noise_strength": rng.randf_range(0.08, 0.12),
			"noise_speed": rng.randf_range(0.15, 0.3),
		
			"scanline_noise_strength": rng.randf_range(0.75, 1.0),
			"interference_strength": rng.randf_range(0.65, 0.9),
		
			"glitch_flicker_strength": 0.25,
		
			"radial_vignette_alpha": rng.randf_range(0.55, 0.8),
			"radial_vignette_inner_radius": rng.randf_range(0.0, 0.25),
			"radial_vignette_outer_radius": rng.randf_range(0.8, 1.2),
			"glitch_dropout_strength": rng.randf_range(0.35, 0.5),
			
			"animated_scanline_thickness_1": rng.randf_range(0.65, 0.82),
			"animated_scanline_thickness_2": rng.randf_range(0.35, 0.5)
	}

	#
	#var glitch_settings: Dictionary = {
		#"border_color": glitch_border,
#
		## High-contrast thick scanlines
		#"scanlines": rng.randf_range(0.65, 0.85),
		## "scanlines": rng.randf_range(0.8, 1.0),
		#"scanline_size": rng.randf_range(2.0, 4.0),
#
		## Strong vignette
		#"vignette": rng.randf_range(0.8, 1.0),
#
		## Overexposure during flashes
		#"brightness": rng.randf_range(1.1, 1.4),
		## "brightness": rng.randf_range(1.4, 2.0),
#
		## Strong RGB-mask
		#"rgb_mask": true,
		#"mask_strength": rng.randf_range(0.4, 0.65),
		## "mask_strength": rng.randf_range(0.8, 1.0),
#
		## High-frequency scanlines
		#"scanlines_1": rng.randf_range(750.0, 1000.0),
		#"scanlines_2": rng.randf_range(60.0, 160.0),
#
		## Strong scanline flicker
		#"scan_reduction": rng.randf_range(0.15, 0.25),
		## "scan_reduction": rng.randf_range(0.3, 0.5),
#
		## Fast chaotic scanline movement
		#"animated_scan_speed_1": rng.randf_range(0.0, 0.005),
		#"animated_scan_speed_2": rng.randf_range(0.0, 0.02),
		## "animated_scan_speed_1": rng.randf_range(2.0, 5.0),
		## "animated_scan_speed_2": rng.randf_range(1.5, 5.0),
#
		## Intense noise
		#"noise_strength": rng.randf_range(0.03, 0.06),
		#"noise_speed": rng.randf_range(0.5, 2.0),
		## "noise_strength": rng.randf_range(0.16, 0.25),
		## "noise_speed": rng.randf_range(30.0, 60.0),
#
		## Strong radial vignette
		#"radial_vignette_alpha": rng.randf_range(0.7, 1.0),
		#"radial_vignette_inner_radius": rng.randf_range(0.0, 0.25),
		#"radial_vignette_outer_radius": rng.randf_range(0.65, 1.2),
#
		## Chaotic brightness flashes
		#"glitch_flicker_strength": 0.5
		## "glitch_flicker_strength": 1.0
	#}

	# Applying all settings at once
	_apply_settings(glitch_settings)

	# Play glitch sound
	if glitch_audio_player != null:
		glitch_audio_player.play()

	# Don't start new timer, while is glitched
	# CRT is glitched until Hit


# ------------------------------------------------------------
# FIX: RESET TO DEFAULT
# ------------------------------------------------------------

func _on_reset_button_pressed() -> void:
	# Reset default settings
	_apply_default_settings()

	is_glitched = false

	# Hit sound
	if fix_audio_player != null:
		fix_audio_player.play()

	# Start glitch timer
	_schedule_next_glitch()


# ------------------------------------------------------------
# ADDITIONAL FUNC
# ------------------------------------------------------------

func _apply_default_settings() -> void:
	_apply_settings(DEFAULT_SETTINGS)


func _apply_settings(settings: Dictionary) -> void:
	if shader_material == null:
		return

	for parameter_name in settings:
		shader_material.set_shader_parameter(
			parameter_name,
			settings[parameter_name]
		)
