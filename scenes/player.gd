extends CharacterBody2D
@onready var tiles: TileMapLayer = $"../TileMapLayer"
var is_player_turn = true
const tile_size: Vector2 = Vector2(16,16)


func _ready() -> void:
	TurnManager.enemy_action_done.connect(on_enemy_action_done)

func on_enemy_action_done() -> void:
	is_player_turn = true
	
func _physics_process(_delta: float) -> void:
	var x_input = Input.get_axis("left","right")
	var y_input = Input.get_axis("up","down")
	
	var look_dir = Vector2(x_input,y_input)
	
	if look_dir != Vector2.ZERO && is_player_turn:
		match look_dir:
			Vector2(0,1):
				look_down()
				if Input.is_action_just_pressed("space") && !$down.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(1,1):
				look_down_right()
				if Input.is_action_just_pressed("space") && !$down_right.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(1,0):
				look_right()
				if Input.is_action_just_pressed("space") && !$right.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(1,-1):
				look_up_right()
				if Input.is_action_just_pressed("space") && !$up_right.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(0,-1):
				look_up()
				if Input.is_action_just_pressed("space") && !$up.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(-1,-1):
				look_up_left()
				if Input.is_action_just_pressed("space") && !$up_left.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(-1,0):
				look_left()
				if Input.is_action_just_pressed("space") && !$left.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
			Vector2(-1,1):
				look_down_left()
				if Input.is_action_just_pressed("space") && !$down_left.is_colliding():
					global_position += look_dir * tile_size
					done_with_turn()
	else:
		look_down()

func done_with_turn():
	is_player_turn = false
	TurnManager.player_action_done.emit()

func look_down(): $CharacterSprite2D.frame = 0
func look_down_right(): $CharacterSprite2D.frame = 1
func look_right(): $CharacterSprite2D.frame = 2
func look_up_right(): $CharacterSprite2D.frame = 3
func look_up(): $CharacterSprite2D.frame = 4
func look_up_left(): $CharacterSprite2D.frame = 5
func look_left(): $CharacterSprite2D.frame = 6
func look_down_left(): $CharacterSprite2D.frame = 7
