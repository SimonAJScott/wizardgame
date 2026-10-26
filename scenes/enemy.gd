extends CharacterBody2D
const tile_size: Vector2 = Vector2(16,16)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randomX = randi_range(1, 5)*(tile_size.x)-tile_size.y/2
	var randomY = randi_range(1, 5)*(tile_size.y)-tile_size.y/2
	position = Vector2(randomX,randomY)
	print(position)
	$AnimatedSprite2D.play("idle_down")
	TurnManager.player_action_done.connect(on_player_action_done)

func on_player_action_done():
	print("enemy acted")
	TurnManager.enemy_action_done.emit()
	
	
