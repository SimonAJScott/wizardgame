extends Node2D
#rename tiles/rooms/floors

var player_scene: PackedScene = preload("res://scenes/player.tscn") 
var enemy_scene: PackedScene = preload("res://scenes/enemies/act_1/enemy.tscn")
var map_generator_scene: PackedScene = preload("res://scenes/map_generator.tscn")
var tile_map_path_scene: PackedScene = preload("res://scenes/path_rooms/tile_map_layer_path.tscn")
var path_scene_counter: int = 0
var tile_map_event_scene: PackedScene = preload("res://scenes/event_rooms/tile_map_layer_event.tscn")
var tile_map_start_scene: PackedScene = preload("res://scenes/start_rooms/tile_map_layer_start.tscn")
var tile_map_exit_scene: PackedScene = preload("res://scenes/exit_rooms/tile_map_layer_exit.tscn")
var tile_map_treasure_scene: PackedScene = preload("res://scenes/treasure_rooms/tile_map_layer_treasure.tscn")
var tile_map_background_scene: PackedScene = preload("res://scenes/background_rooms/tile_map_layer_background.tscn")
var background_scene_counter: int = 0
var enemy_scene_counter: int = 0
var collision_tiles = {}
var valid_spawn_tiles = {}
var floor = []


func _ready() -> void:
	
	#add tiles to map
	var map_generator = map_generator_scene.instantiate() as Node2D
	add_child(map_generator)
	floor = map_generator.get_floor()
	place_tiles(Global.floor_height,Global.floor_width)
	#add player to map
	var player = player_scene.instantiate() as CharacterBody2D
	add_child(player)
	player.add_to_group("player")
	#add test enemies
	spawn_enemies_randomly()

func place_tiles(floor_height: int, floor_width: int) -> void:
	for y in range(floor_height):
		for x in range(floor_width):
			match floor[x][y]:
				#initialize each tile
				"S":
					var start_room = tile_map_start_scene.instantiate() as Node2D
					start_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(start_room,x,y)
					add_child(start_room)
				"T":
					var treasure_room = tile_map_treasure_scene.instantiate() as Node2D
					treasure_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(treasure_room,x,y)
					add_child(treasure_room)
				"E":
					var event_room = tile_map_event_scene.instantiate() as Node2D
					event_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(event_room,x,y)
					add_child(event_room)
				"X":
					var exit_room = tile_map_exit_scene.instantiate() as Node2D
					exit_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					initialize_collisions(exit_room,x,y)
					add_child(exit_room)
				"P":
					var path_room = tile_map_path_scene.instantiate() as Node2D
					path_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					path_room.set_name("TileMapLayer_Path_" + str(path_scene_counter))
					path_scene_counter += 1
					initialize_collisions(path_room,x,y)
					add_child(path_room)
				_:
					var background_room = tile_map_background_scene.instantiate() as Node2D
					background_room.position = Global.tile_get_pixel_from_grid(Vector2i(x,y))
					background_room.set_name("TileMapLayer_Background_" + str(background_scene_counter))
					background_scene_counter += 1
					initialize_collisions(background_room,x,y)
					add_child(background_room)

func spawn_enemies_randomly() -> void:
	#add not collision tiles and path tiles to valid spawn tiles
	for x in range(Global.tiles_in_room*Global.floor_width):
		for y in range(Global.tiles_in_room*Global.floor_height):
			var possible_tile = Vector2i(x,y)
			var floor_location = Global.get_floor_location_from_grid(possible_tile)
			if !collision_tiles.has(possible_tile)&& floor[floor_location.x][floor_location.y] == 'P':
				valid_spawn_tiles.set(possible_tile,null)
				
	#remove 8 spaces away from player
	for tile in Global.get_all_tiles_in_radius(Global.player_spawn_tile,8):
		valid_spawn_tiles.erase(tile)
	
	#spawn enemies
	for i in range(0,Global.current_num_enemies):
		var random_tile: Vector2i = valid_spawn_tiles.keys().pick_random()
		var test_enemy = enemy_scene.instantiate().setup(collision_tiles) as CharacterBody2D
		test_enemy.position = Global.get_pixel_from_grid(random_tile)
		test_enemy.set_name("Enemy_" + str(enemy_scene_counter))
		enemy_scene_counter+=1
		add_child(test_enemy)
		add_to_group("enemies")
		valid_spawn_tiles.erase(random_tile)
		#remove spawn from 2 tiles of enemy
		for tile in Global.get_all_tiles_in_radius(random_tile,2):
			valid_spawn_tiles.erase(tile)

func initialize_collisions(tile,x:int,y:int) -> void:
	#tile: [enviornment,physics]
	for candidate_tile in tile.get_child(1).get_used_cells():
		collision_tiles.set(Vector2i((x*Global.tile_size.x/2)+candidate_tile.x,(y*Global.tile_size.y/2)+candidate_tile.y),null)
