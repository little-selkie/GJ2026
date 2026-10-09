extends Node2D

@export var Grid: Node2D

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
	if GlobalVars.move_array[GlobalVars.move_step] == "Down":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)
	if GlobalVars.move_array[GlobalVars.move_step] == "Left":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)
	if GlobalVars.move_array[GlobalVars.move_step] == "Right":
		if Grid.check_if_wall(Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)):
			Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)
	if MCOriginPoint_temp != Grid.MCOriginPoint_atlas:
		Grid.get_global_coords(Grid.MCOriginPoint_atlas)
		global_position = Grid.MCOriginPoint
		print("move")


func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVars.coins = 0
	GlobalVars.move_array = []
	get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	if GlobalVars.move_step <= GlobalVars.move_array.size()-1:
		move()
		GlobalVars.move_step = GlobalVars.move_step + 1
	else:
		GlobalVars.coins = 0
		get_tree().reload_current_scene()
