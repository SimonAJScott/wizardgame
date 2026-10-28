extends Node

const tile_size: Vector2 = Vector2(16,16)

func get_grid_from_pixel(pixel_vector: Vector2i) -> Vector2i:
	var grid_int_x: int = (pixel_vector.x-Global.tile_size.x/2)/Global.tile_size.x
	var grid_int_y: int = (pixel_vector.y-Global.tile_size.y/2)/Global.tile_size.y
	return Vector2i(grid_int_x,grid_int_y)

func get_pixel_from_grid(grid_vector: Vector2i) -> Vector2i:
	var pixel_int_x: int = grid_vector.x*Global.tile_size.x+Global.tile_size.x/2
	var pixel_int_y: int = grid_vector.y*Global.tile_size.y+Global.tile_size.y/2
	return Vector2i(pixel_int_x,pixel_int_y)
