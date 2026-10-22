extends CharacterBody2D

const TILE_SIZE: int = 16
const MOVE_SPEED: float = 0.75

var is_moving: bool = false
var target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	position = position.snapped(Vector2(TILE_SIZE,TILE_SIZE))
	target_position = position
	$AnimatedSprite2D.play("idle")
	
func _physics_process(_delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_position,MOVE_SPEED)
		if position == target_position:
			is_moving = false
	else:
		var direction := Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			direction = Vector2.RIGHT
		elif Input.is_action_pressed("ui_left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("ui_down"):
			direction = Vector2.DOWN
		elif Input.is_action_pressed("ui_up"):
			direction = Vector2.UP
			
		if direction != Vector2.ZERO:
			target_position = position + (direction * TILE_SIZE)
			is_moving = true

	
	
