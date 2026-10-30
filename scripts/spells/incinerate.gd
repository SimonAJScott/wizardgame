extends Node2D

var mana_cost = 15
var turn_cooldown = 1
var damage = 25
@onready var incinerate_sound: AudioStreamPlayer2D = $IncinerateSound

var casting_directions = {
	Vector2.UP:{Vector2i(0,-1):null,Vector2i(0,-2):null,Vector2i(1,-2):null,Vector2i(-1,-2):null},
	Vector2.DOWN:{Vector2i(1,2):null,Vector2i(-1,2):null,Vector2i(0,1):null,Vector2i(0,2):null},
	Vector2.LEFT:{Vector2i(-1,0):null,Vector2i(-2,0):null,Vector2i(-2,1):null,Vector2i(-2,-1):null},
	Vector2.RIGHT:{Vector2i(1,0):null,Vector2i(2,0):null,Vector2i(2,1):null,Vector2i(2,-1):null},
	Vector2(1, 1): {Vector2i(1,1):null,Vector2i(2,1):null,Vector2i(2,2):null,Vector2i(1,2):null},
	Vector2(1, -1): {Vector2i(1,-1):null,Vector2i(2,-1):null,Vector2i(2,-2):null,Vector2i(1,-2):null},
	Vector2(-1, -1): {Vector2i(-1,-1):null,Vector2i(-2,-1):null,Vector2i(-2,-2):null,Vector2i(-1,-2):null},
	Vector2(-1, 1): {Vector2i(-1,1):null,Vector2i(-2,1):null,Vector2i(-2,2):null,Vector2i(-1,2):null}
	}

func setup(spell_direction: Vector2, is_aim: bool,player_vector:Vector2) -> void:
	position.x = position.x - Global.tile_size.x/2
	position.y = position.y - Global.tile_size.y/2
	var incinerate_tile_map_layer_visual:TileMapLayer = get_node("IncinerateVisual")
		
	for texture_vector in casting_directions.get(spell_direction):
		if is_aim:
			incinerate_tile_map_layer_visual.set_cell(texture_vector,0,Vector2(17,5))
		else:
			incinerate_tile_map_layer_visual.set_cell(texture_vector,0,Vector2(2,0))
			for entity in get_tree().get_nodes_in_group("entities"):
				if entity.name == "Player":
					continue
				
				if Global.get_grid_from_pixel(Vector2i(entity.global_position)) == Vector2i(Vector2i(player_vector) + texture_vector):
					
					entity.damage_dealt(damage)
				
	if !is_aim:
		incinerate_sound.play()

func get_mana_cost() -> int:
	return mana_cost
