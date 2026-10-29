extends CharacterBody2D

const attack_tiles_funcs = {
	Vector2i(0,-1):null,Vector2i(0,-2):null,
	Vector2i(0,1):null,Vector2i(0,2):null,
	Vector2i(-1,0):null,Vector2i(-2,0):null,
	Vector2i(1,0):null,Vector2i(2,0):null,
	Vector2i(1,1):null,Vector2i(2,2):null,
	Vector2i(1,-1):null,Vector2i(2,-2):null,
	Vector2i(-1,-1):null,Vector2i(-2,-2):null,
	Vector2i(-1,1):null,Vector2i(-2,2):null
}


var max_health: int
var current_health: int
var collisions = {}
var attack_range = 2
var player_location:Vector2
var current_location:Vector2
var damage = 10

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
	print(name + ": enemy acted")
	TurnManager.enemy_action_done.emit()

func damage_dealt(amount: int) -> void:
	current_health -= amount
	update_health_ui()
	if current_health <= 0:
		Global.current_num_enemies -= 1
		queue_free()

func update_health_ui() -> void:
	$HealthBar.value = current_health
	$HealthBar.max_value = max_health

func do_attack()-> void:
	for entity in get_tree().get_nodes_in_group("entities"):
		if entity.name == "Player":
			entity.damage_dealt(damage)
	
	await get_tree().create_timer(0.5).timeout
	
func is_player_in_attack_range() -> bool:
	for attack in attack_tiles_funcs:
		if attack+Vector2i(current_location) == Vector2i(player_location):
			return true
	return false

func action_move_towards_player() -> void:
	var path = find_path_towards_player()
	path.pop_front()
	if is_player_in_attack_range():
		do_attack()
	else:
		position = Global.get_pixel_from_grid(path.front())

func find_path_towards_player() -> Array[Vector2i]:
	var astargrid = AStarGrid2D.new() 
	astargrid.size = Vector2i(72,72)
	astargrid.cell_size = Vector2i(16,16)
	astargrid.update()
	for cell in collisions:
		astargrid.set_point_solid(cell, true)
	for tile in get_other_entity_tiles():
		astargrid.set_point_solid(tile, true)
	player_location = find_player_location()
	current_location = Global.get_grid_from_pixel(Vector2i(position.x,position.y))
	var path = astargrid.get_id_path(current_location,player_location)
	return path

func find_player_location() -> Vector2i:
	var all_entities = get_tree().get_nodes_in_group("entities")
	var return_vector = Vector2i.ZERO
	for entity:CharacterBody2D in all_entities:
		if entity.name == "Player":
			return_vector = Global.get_grid_from_pixel(Vector2i(entity.position.x,entity.position.y))
	return return_vector
	
func get_other_entity_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for entity in get_tree().get_nodes_in_group("entities"):
		if entity == self or entity.name == "Player":
			continue
		tiles.append(Global.get_grid_from_pixel(Vector2i(entity.position)))
	return tiles
