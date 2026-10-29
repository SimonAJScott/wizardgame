extends Node2D

var floor: Array[Array] = []


func _ready() -> void:
	reset_floor()
	generate_path()
	print_floor()

func print_floor() -> void:
	print("GENERATING FLOOR")
	var header = "y/x "
	for x in range(Global.floor_width):
		header += "%2d " % x
	print(header)
	for y in range(Global.floor_width):
		var row_string = "%3d " % y
		for x in range(Global.floor_height):
			row_string += "[" + str(floor[x][y]) + "]"
		print(row_string)

func generate_path() -> void:
	#pick random starting room (S)
	floor[Global.start_room_location.x][Global.start_room_location.y] = "S"
	#pick random direction
	#if legal, create room, set as new current room, reduce rooms left counter 
	#else pick a different direction
	var path = add_rooms(randi_range(Global.minimum_rooms,Global.maximum_rooms-1),Global.start_room_location)
	var adjacent_rooms = find_all_open_adjacent_rooms_along_path(path)
	
	#pick random room to be event
	var random_event_room = adjacent_rooms.keys().pick_random()
	adjacent_rooms.erase(random_event_room)
	floor[random_event_room.x][random_event_room.y] = "E"
	
	#pick random room to be chest
	var random_chest_room = adjacent_rooms.keys().pick_random()
	adjacent_rooms.erase(random_chest_room)
	floor[random_chest_room.x][random_chest_room.y] = "T"
	
func add_rooms(rooms_left: int,current_room: Vector2i) -> Array:
	var current_path: Array = []
	if rooms_left < 0:
		return current_path
	
	if current_path.is_empty() or current_path.back() != current_room:
		current_path.append(current_room)
	
	while rooms_left > 0:
		# No earlier rooms remain to search from.
		if current_path.is_empty():
			return current_path

		# Look at the last room WITHOUT removing it.
		var check_from_room: Vector2i = current_path.back()
		var available_rooms: Array[Vector2i] = check_all_four_directions(check_from_room)

		# Only backtrack after finding that ALL neighbors are blocked.
		if available_rooms.is_empty():
			current_path.pop_back()
			continue

		# Create a room in one of the available cells.
		var next_room: Vector2i = available_rooms.pick_random()
		
	
		# Remember this room so we can return to it later.
		current_path.append(next_room)
		
		#last room is exit room
		if rooms_left == 1:
			floor[next_room.x][next_room.y] = "X"
		else:
			#change to P later
			floor[next_room.x][next_room.y] = "P"
		rooms_left -= 1
	return current_path
	
func find_all_open_adjacent_rooms_along_path(path: Array) -> Dictionary:
	#remove starting room
	path.pop_front()
	#remove ending room
	path.pop_back()
	#initializing dictionary
	var adjacent_rooms: Dictionary = {}
	
	for room in path:
		for adjacent_room in check_all_four_directions(room):
			adjacent_rooms.set(adjacent_room,null)
	return adjacent_rooms

func check_all_four_directions(room:Vector2i) -> Array:
	var available_rooms: Array[Vector2i] = []
	var directions: Array[Vector2i] = [
		Vector2i.UP,
		Vector2i.LEFT,
		Vector2i.DOWN,
		Vector2i.RIGHT
	]
	# Check all four directions. continue skips until next loop
	for direction in directions:
		var candidate: Vector2i = room + direction

		if candidate.x < 0 or candidate.x >= Global.floor_width:
			continue

		if candidate.y < 0 or candidate.y >= Global.floor_height:
			continue

		if floor[candidate.x][candidate.y] == "0":
			available_rooms.append(candidate)
	return available_rooms

func reset_floor() -> void:
	floor.resize(Global.floor_width)
	for x in range(Global.floor_width):
		floor[x] = []
		floor[x].resize(Global.floor_height)
		for y in range(Global.floor_height):
			floor[x][y] = "0"

func get_floor() -> Array:
	return floor
