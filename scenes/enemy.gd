extends CharacterBody2D
const tile_size: Vector2 = Vector2(16,16)
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

func _ready() -> void:
	var randomX = randi_range(1, 8)*(tile_size.x)-tile_size.y/2
	var randomY = randi_range(1, 8)*(tile_size.y)-tile_size.y/2
	position = Vector2(randomX,randomY)
	print(position)
	$AnimatedSprite2D.play("idle_down")
	TurnManager.player_action_done.connect(on_player_action_done)

func on_player_action_done():
	print("enemy acted")
	position += directions.pick_random() * tile_size
	TurnManager.enemy_action_done.emit()
