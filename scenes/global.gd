extends Node

const tile_size: Vector2 = Vector2(16,16)
const tiles_in_room: int = 8
const floor_width = 9
const floor_height = 9
const minimum_rooms = 6
const maximum_rooms = 9
const start_room_grid = Vector2i(4,4)
var current_num_enemies = 10

func get_grid_from_pixel(pixel_vector: Vector2i) -> Vector2i:
	var grid_int_x: int = (pixel_vector.x-Global.tile_size.x/2)/Global.tile_size.x
	var grid_int_y: int = (pixel_vector.y-Global.tile_size.y/2)/Global.tile_size.y
	return Vector2i(grid_int_x,grid_int_y)

func get_pixel_from_grid(grid_vector: Vector2i) -> Vector2i:
	var pixel_int_x: int = grid_vector.x*Global.tile_size.x+Global.tile_size.x/2
	var pixel_int_y: int = grid_vector.y*Global.tile_size.y+Global.tile_size.y/2
	return Vector2i(pixel_int_x,pixel_int_y)
	
func tile_get_pixel_from_grid(grid_vector: Vector2i) -> Vector2i:
	var pixel_int_x: int = grid_vector.x*Global.tile_size.x*tiles_in_room
	var pixel_int_y: int = grid_vector.y*Global.tile_size.y*tiles_in_room
	return Vector2i(pixel_int_x,pixel_int_y)
	
