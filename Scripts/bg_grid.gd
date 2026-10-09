extends Node2D

var MCOriginPoint: Vector2 
var MCOriginPoint_atlas: Vector2i 
@export var coin_object: PackedScene
@export var wall_object: PackedScene
@export var door_object: PackedScene

func _ready() -> void:
	$StepTimer.wait_time = GlobalVars.time_step
	$ActionGrid.visible = false
	for tile_position in $ActionGrid.get_used_cells():
		if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("mc_origin_point") == true:
			get_global_coords(tile_position)
			MCOriginPoint_atlas = tile_position
			break
		else:
			print("not working")
	print(MCOriginPoint)
	if coin_object != null:
		for tile_position in $ActionGrid.get_used_cells():
			var coin
			var coin_spawn_location
			if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("coin_tile") == true:
				coin = coin_object.instantiate()
				coin_spawn_location = $ActionGrid.map_to_local(tile_position)
				coin.global_position = coin_spawn_location
				$Coins.add_child(coin)
	if wall_object != null:
		for tile_position in $ActionGrid.get_used_cells():
			var wall
			var wall_spawn_location
			var door
			var door_spawn_location
			if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("is_not_traversable") == true and $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("door") == false:
				wall = wall_object.instantiate()
				wall_spawn_location = $ActionGrid.map_to_local(tile_position)
				wall.global_position = wall_spawn_location
				$Walls.add_child(wall)
			if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("is_not_traversable") == true and $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("door") == true:
				door = door_object.instantiate()
				door_spawn_location = $ActionGrid.map_to_local(tile_position)
				door.global_position = door_spawn_location
				door.name = "TheDoor"
				$Walls.add_child(door)

func get_global_coords(tile_position) -> void:
	if $ActionGrid.get_cell_tile_data(tile_position) != null:
		if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("is_not_traversable") == true:
			pass
		else:
			MCOriginPoint = $ActionGrid.map_to_local(tile_position)
	else:
		MCOriginPoint = $ActionGrid.map_to_local(tile_position)

func place_enemies() -> Array:
	var place_coordinates = Vector2(0,0)
	var coordinates_atlas
	for tile_position in $ActionGrid.get_used_cells():
		if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("enemy_origin_point") == true:
			place_coordinates = $ActionGrid.map_to_local(tile_position)
			coordinates_atlas = tile_position
			$ActionGrid.erase_cell(tile_position)
			break
		else:
			pass
	return [place_coordinates, coordinates_atlas]

func enemy_move_to(tile_coordinates) -> Vector2:
	var global_coords = $ActionGrid.map_to_local(tile_coordinates)
	return global_coords

func check_if_wall(tile_coordinates) -> bool:
	var is_wall = 0
	if $ActionGrid.get_cell_tile_data(tile_coordinates) != null:
		if $ActionGrid.get_cell_tile_data(tile_coordinates).get_custom_data("is_not_traversable") == true:
			is_wall = 0
			$WallHit.play()
		else:
			is_wall = 1
	else:
		is_wall = 1
	return is_wall

func open_the_door() -> void:
	door_object.get_child(0).visible = false
	for tile_position in $ActionGrid.get_used_cells():
		if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("door") == true:
			$ActionGrid.erase_cell(tile_position)
