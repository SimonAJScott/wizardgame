extends Node2D

var floor: Array[Array] = []
var floor_path: Array
const floor_width = 4
const floor_height = 4
const minimum_rooms = 6
const maximum_rooms = 9


func _ready() -> void:
	reset_floor()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		reset_floor()
		generate_path()
		print_floor()

func print_floor() -> void:
	print("GENERATING FLOOR")
	var header = "y/x "
	for x in range(floor_width):
		header += "%2d " % x
	print(header)
	for y in range(floor_width):
		var row_string = "%3d " % y
		for x in range(floor_height):
			row_string += "[" + str(floor[x][y]) + "]"
		print(row_string)
	


func generate_path() -> void:
	#pick random starting room (S)
	var start_room = Vector2i(randi_range(0,3),randi_range(0,3))
	floor[start_room.x][start_room.y] = "S"
	#pick random direction
	#if legal, create room, set as new current room, reduce rooms left counter 
	#else pick a different direction
	var path = add_rooms(randi_range(minimum_rooms,maximum_rooms-1),start_room)
	var adjacent_rooms = find_all_open_adjacent_rooms_along_path(path)
	#pick random room to be event
	var random_event_room = adjacent_rooms.keys().pick_random()
	floor[random_event_room.x][random_event_room.y] = "E"
	
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
			floor[next_room.x][next_room.y] = str(rooms_left)
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

		if candidate.x < 0 or candidate.x >= floor_width:
			continue

		if candidate.y < 0 or candidate.y >= floor_height:
			continue

		if floor[candidate.x][candidate.y] == "0":
			available_rooms.append(candidate)
	return available_rooms

func reset_floor() -> void:
	floor.resize(floor_width)
	for x in range(floor_width):
		floor[x] = []
		floor[x].resize(floor_height)
		for y in range(floor_height):
			floor[x][y] = "0"
