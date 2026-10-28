extends Node2D
#rename tiles/rooms/floors

var player_scene: PackedScene = preload("res://scenes/player.tscn") 
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var map_generator_scene: PackedScene = preload("res://scenes/map_generator.tscn")
var tile_map_path_scene: PackedScene = preload("res://scenes/tile_map_layer_path.tscn")
var path_scene_counter: int = 0
var tile_map_event_scene: PackedScene = preload("res://scenes/tile_map_layer_event.tscn")
var tile_map_start_scene: PackedScene = preload("res://scenes/tile_map_layer_start.tscn")
var tile_map_exit_scene: PackedScene = preload("res://scenes/tile_map_layer_exit.tscn")
var tile_map_treasure_scene: PackedScene = preload("res://scenes/tile_map_layer_treasure.tscn")
var tile_map_background_scene: PackedScene = preload("res://scenes/tile_map_layer_background.tscn")
var background_scene_counter: int = 0
var enemy_scene_counter: int = 0
var collision_tiles = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#add tiles to map
	var map_generator = map_generator_scene.instantiate() as Node2D
	add_child(map_generator)
	var floor = map_generator.get_floor()
	place_tiles(floor,map_generator.get_floor_height(),map_generator.get_floor_width())
	#add player to map
	var player = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	#add test enemy
	spawn_enemies_randomly()
	
	
	

func place_tiles(floor: Array[Array], floor_height: int, floor_width: int) -> void:
	for y in range(floor_height):
		for x in range(floor_width):
			match floor[x][y]:
				#initialize each tile
				"S":
					var start_tile = tile_map_start_scene.instantiate() as Node2D
					start_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(start_tile,x,y)
					add_child(start_tile)
				"T":
					var treasure_tile = tile_map_treasure_scene.instantiate() as Node2D
					treasure_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(treasure_tile,x,y)
					add_child(treasure_tile)
				"E":
					var event_tile = tile_map_event_scene.instantiate() as Node2D
					event_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(event_tile,x,y)
					add_child(event_tile)
				"X":
					var exit_tile = tile_map_exit_scene.instantiate() as Node2D
					exit_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(exit_tile,x,y)
					add_child(exit_tile)
				"P":
					var path_tile = tile_map_path_scene.instantiate() as Node2D
					path_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					path_tile.set_name("TileMapLayer_Path_" + str(path_scene_counter))
					path_scene_counter += 1
					initialize_collisions(path_tile,x,y)
					add_child(path_tile)
				_:
					var background_tile = tile_map_background_scene.instantiate() as Node2D
					background_tile.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					background_tile.set_name("TileMapLayer_Background_" + str(background_scene_counter))
					background_scene_counter += 1
					initialize_collisions(background_tile,x,y)
					add_child(background_tile)

func spawn_enemies_randomly() -> void:
	var valid_cells: Dictionary = {}
	for x in range(Global.tiles_in_room*Global.floor_width):
		for y in range(Global.tiles_in_room*Global.floor_height):
			var possible_tile = Vector2i(x,y)
			if !collision_tiles.has(possible_tile):
				valid_cells.set(possible_tile,null)
	for i in range(0,Global.current_num_enemies):
		var random_cell: Vector2i = valid_cells.keys().pick_random()
		var test_enemy = enemy_scene.instantiate().setup(collision_tiles) as CharacterBody2D
		test_enemy.position = Global.get_pixel_from_grid(random_cell)
		test_enemy.set_name("Enemy_" + str(enemy_scene_counter))
		enemy_scene_counter+=1
		add_child(test_enemy)
		add_to_group("enemies")
		valid_cells.erase(random_cell)

func initialize_collisions(tile,x:int,y:int) -> void:
	for cell in tile.get_child(1).get_used_cells():
		collision_tiles.set(Vector2i((x*8)+cell.x,(y*8)+cell.y),null)
