extends CharacterBody2D

# var game: PackedScene = preload("res://scenes/game.tscn")

const directions = [
	Vector2(0,1), #down
	Vector2(1,1), #down right
	Vector2(1,0), #right
	Vector2(-1,1), #up right
	Vector2(-1,0), #up
	Vector2(-1,-1), #up left
	Vector2(-1,0), #left
	Vector2(-1,1), #down left
]


var max_health: int
var current_health: int
var collisions = {}

func setup(collision_tiles: Dictionary) -> CharacterBody2D:
	collisions = collision_tiles
	return self

func _ready() -> void:
	$AnimatedSprite2D.play("idle_down")
	TurnManager.player_action_done.connect(on_player_action_done)
	max_health = 100
	current_health = max_health
	update_health_ui()

func on_player_action_done():
	action_move_towards_player()
	print("enemy acted")
	TurnManager.enemy_action_done.emit()
	
func update_health_ui() -> void:
	$HealthBar.value = current_health
	$HealthBar.max_value = max_health

func action_move_towards_player() -> void:
	var path = find_path_towards_player()
	path.pop_front()
	position = Global.get_pixel_from_grid(path.front())

#find all collisions to player

func find_path_towards_player() -> Array[Vector2i]:
	var astargrid = AStarGrid2D.new() 
	astargrid.size = Vector2i(72,72)
	astargrid.cell_size = Vector2i(16,16)
	astargrid.update()
	for cell in collisions:
		#print(cell)
		astargrid.set_point_solid(cell, true)
	
	var path = astargrid.get_id_path(Global.get_grid_from_pixel(Vector2i(position.x,position.y)),find_player_location())
	
	#print(path)
	return path

func find_player_location() -> Vector2i:
	var all_entities = get_tree().get_nodes_in_group("entities")
	var return_vector = Vector2i.ZERO
	for entity:CharacterBody2D in all_entities:
		if entity.name == "Player":
			return_vector = Global.get_grid_from_pixel(Vector2i(entity.position.x,entity.position.y))
	return return_vector
