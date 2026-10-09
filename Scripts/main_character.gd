extends Node2D

@export var Grid: Node2D

func _ready() -> void:
	if Grid != null:
		global_position = Grid.MCOriginPoint
	else:
		queue_free()

func _process(_elta: float) -> void:
	move()

func move() -> void:
	var MCOriginPoint_temp: Vector2i = Grid.MCOriginPoint_atlas
	if Input.is_action_just_pressed("Move Up"):
		Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y - 1)
	if Input.is_action_just_pressed("Move Down"):
		Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x, Grid.MCOriginPoint_atlas.y + 1)
	if Input.is_action_just_pressed("Move Left"):
		Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x - 1, Grid.MCOriginPoint_atlas.y)
	if Input.is_action_just_pressed("Move Right"):
		Grid.MCOriginPoint_atlas = Vector2i(Grid.MCOriginPoint_atlas.x + 1, Grid.MCOriginPoint_atlas.y)
	if MCOriginPoint_temp != Grid.MCOriginPoint_atlas:
		Grid.get_global_coords(Grid.MCOriginPoint_atlas)
		global_position = Grid.MCOriginPoint
		print("move")
