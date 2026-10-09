extends Node2D

var MCOriginPoint: Vector2 
var MCOriginPoint_atlas: Vector2i 
@export var coin_object: PackedScene

func _ready() -> void:
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

func get_global_coords(tile_position) -> void:
	MCOriginPoint = $ActionGrid.map_to_local(tile_position)
