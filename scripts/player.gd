extends CharacterBody2D
var is_player_turn = true

var incenerate_spell_scene: PackedScene = preload("res://scenes/spells/incinerate.tscn")

var current_mana: int
var current_health: int
var max_mana: int = 100
var max_health: int = 100
var active_spell:Node2D = null
var is_casting := false
var looking_dir:Vector2 = Vector2.DOWN
var gold: int = 0
var spell_1 = null
var spell_2 = null
var spell_3 = null
var spell_4 = null

@onready var rays := {
	Vector2(0, 1): $down,
	Vector2(1, 1): $down_right,
	Vector2(1, 0): $right,
	Vector2(1, -1): $up_right,
	Vector2(0, -1): $up,
	Vector2(-1, -1): $up_left,
	Vector2(-1, 0): $left,
	Vector2(-1, 1): $down_left,
}

@onready var look_funcs := {
	Vector2(0, 1): look_down,
	Vector2(1, 1): look_down_right,
	Vector2(1, 0): look_right,
	Vector2(1, -1): look_up_right,
	Vector2(0, -1): look_up,
	Vector2(-1, -1): look_up_left,
	Vector2(-1, 0): look_left,
	Vector2(-1, 1): look_down_left,
}

func _ready() -> void:
	position = Global.get_pixel_from_grid(Global.player_spawn_tile)
	TurnManager.enemy_action_done.connect(on_enemy_action_done)
	TurnManager.collect_gold.connect(on_collect_gold)
	current_mana = max_mana
	current_health = max_health
	update_health_ui()
	update_mana_ui()
	look_down()
	spell_1 = incenerate_spell_scene.instantiate() as Node2D
	add_child(spell_1)

func _physics_process(delta: float) -> void:
	if current_health <= 0:
		TurnManager.player_died.emit()
		queue_free()
	process_action()

func damage_dealt(amount: int) -> void:
	current_health -= amount
	update_health_ui()
	


func process_action() -> void:
	if is_casting:
		return
	if Global.current_num_enemies > 0 and not is_player_turn:
		return
	
	if Input.is_action_just_pressed("spell_1"):
		start_aim()
	# cancel aiming
	if Input.is_action_just_pressed("space") and active_spell != null:
		cancel_aim()
		return
	# cast spell
	if Input.is_action_just_released("spell_1") and active_spell != null:
		cast_spell()
		return

	# Space moves one tile, but not while aiming
	if Input.is_action_just_pressed("space") and active_spell == null \
			and not rays[looking_dir].is_colliding():
		global_position += looking_dir * Global.tile_size
		done_with_turn()

	# Turning works whether aiming or not
	var input_dir := Vector2(
		int(sign(Input.get_axis("left", "right"))),
		int(sign(Input.get_axis("up", "down")))
	)
	if input_dir == Vector2.ZERO or input_dir == looking_dir:
		return

	looking_dir = input_dir
	look_funcs[looking_dir].call()
	if active_spell != null:
		refresh_aim()
		
func start_aim() -> void:
	if active_spell != null:
		return
	active_spell = spell_1
	active_spell.cast(looking_dir, true, Global.get_grid_from_pixel(position))
	

func refresh_aim() -> void:
	active_spell.reset()
	active_spell = null
	start_aim()

func cancel_aim() -> void:
	active_spell.reset()
	active_spell = null

func cast_spell() -> void:
	is_casting = true
	active_spell.reset()
	active_spell.cast(looking_dir, false, Global.get_grid_from_pixel(position))
	current_mana -= active_spell.mana_cost
	update_mana_ui()
	await get_tree().create_timer(0.5).timeout
	active_spell.reset()
	active_spell = null
	is_casting = false
	done_with_turn()

func on_enemy_action_done() -> void:
	is_player_turn = true

func done_with_turn() -> void:
	is_player_turn = false
	TurnManager.player_action_done.emit()

func update_health_ui() -> void:
	$HealthBar.value = current_health
	$HealthBar.max_value = max_health

func update_mana_ui() -> void:
	$ManaBar.value = current_mana
	$ManaBar.max_value = max_mana

func on_collect_gold(sent_gold: int) -> void:
	gold += sent_gold

func get_gold() -> int:
	return gold

func look_down(): $CharacterSprite2D.frame = 0
func look_down_right(): $CharacterSprite2D.frame = 1
func look_right(): $CharacterSprite2D.frame = 2
func look_up_right(): $CharacterSprite2D.frame = 3
func look_up(): $CharacterSprite2D.frame = 4
func look_up_left(): $CharacterSprite2D.frame = 5
func look_left(): $CharacterSprite2D.frame = 6
func look_down_left(): $CharacterSprite2D.frame = 7


#func look_and_move() -> void:
	#if is_player_turn or Global.current_num_enemies == 0:	
		#if Input.is_action_just_pressed("spell_1"):
					#toggle_spell_aim()
		#
		#if Input.is_action_just_pressed("space") and not rays[looking_dir].is_colliding() and active_spell == null:
			#global_position += looking_dir * Global.tile_size
			#done_with_turn()
		#
		#if Input.is_action_just_pressed("space") and active_spell != null:
			#cast_spell()
			#done_with_turn()
		#
		#var input_dir := Vector2(
			#int(sign(Input.get_axis("left", "right"))),
			#int(sign(Input.get_axis("up", "down")))
		#)
		#
		#if input_dir == Vector2.ZERO:
			#return
#
		#if input_dir != looking_dir:
			#looking_dir = input_dir
			#look_funcs[looking_dir].call()
			#if active_spell != null:
					#if is_instance_valid(active_spell):
						#toggle_spell_aim()
						#toggle_spell_aim()
		#else:
			#return

#func toggle_spell_aim() -> void:
	#if active_spell == null:
		#active_spell = incenerate_spell_scene.instantiate() as Node2D
		#add_child(active_spell) 
		#active_spell.setup(looking_dir,true,Global.get_grid_from_pixel(position))
	#else:
		#if is_instance_valid(active_spell):
			#active_spell.queue_free()
			#active_spell = null

#func cast_spell() -> void:
	#if is_instance_valid(active_spell):
			#active_spell.queue_free()
			#active_spell = null
	#active_spell = incenerate_spell_scene.instantiate() as Node2D
	#add_child(active_spell) 
	#active_spell.setup(looking_dir,false,Global.get_grid_from_pixel(position))
	#await get_tree().create_timer(0.5).timeout
	#toggle_spell_aim()
	
