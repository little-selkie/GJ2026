extends Node2D

var MCOriginPoint: Vector2 
var MCOriginPoint_atlas: Vector2i 

func _ready() -> void:
	for tile_position in $ActionGrid.get_used_cells():
		if $ActionGrid.get_cell_tile_data(tile_position).get_custom_data("mc_origin_point") == true:
			get_global_coords(tile_position)
			MCOriginPoint_atlas = tile_position
			break
		else:
			print("not working")
	print(MCOriginPoint)

func get_global_coords(tile_position) -> void:
	MCOriginPoint = $ActionGrid.map_to_local(tile_position)
