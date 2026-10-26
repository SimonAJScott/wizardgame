extends CharacterBody2D
@onready var tiles: TileMapLayer = $"../TileMapLayer"
var is_player_turn = true
const tile_size: Vector2 = Vector2(16,16)


func _ready() -> void:
	TurnManager.enemy_action_done.connect(on_enemy_action_done)
	$AnimatedSprite2D.play("idle")
	
func _physics_process(_delta: float) -> void:
	if(is_player_turn):
		if Input.is_action_just_pressed("left") && !$left.is_colliding():
			global_position += Vector2.LEFT * tile_size
			is_player_turn = false
			TurnManager.player_action_done.emit()
				
		elif Input.is_action_just_pressed("right") && !$right.is_colliding():
			global_position += Vector2.RIGHT * tile_size
			is_player_turn = false
			TurnManager.player_action_done.emit()
			
				
		elif Input.is_action_just_pressed("up") && !$up.is_colliding():
			global_position += Vector2.UP * tile_size
			is_player_turn = false
			TurnManager.player_action_done.emit()
				
		elif Input.is_action_just_pressed("down") && !$down.is_colliding():
			global_position += Vector2.DOWN * tile_size
			is_player_turn = false
			TurnManager.player_action_done.emit()
			
func on_enemy_action_done() -> void:
	is_player_turn = true
	
