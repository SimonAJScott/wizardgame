extends CharacterBody2D
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

func _ready() -> void:
	position = Global.get_pixel_from_grid(Vector2i(randi_range(0, 15),randi_range(0, 15)))
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
	astargrid.size = Vector2i(32,32)
	astargrid.cell_size = Vector2i(16,16)
	astargrid.update()
	var path = astargrid.get_id_path(Global.get_grid_from_pixel(Vector2i(position.x,position.y)),find_player_location())
	print(path)
	return path

func find_player_location() -> Vector2i:
	var all_entities = get_tree().get_nodes_in_group("entities")
	var return_vector = Vector2i.ZERO
	for entity:CharacterBody2D in all_entities:
		if entity.name == "Player":
			return_vector = Global.get_grid_from_pixel(Vector2i(entity.position.x,entity.position.y))
	return return_vector
	
	
#func find_all_collisions() -> Array[Vector2i]:
	#var collisions = []
	#
	#return path
