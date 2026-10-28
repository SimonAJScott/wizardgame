extends Node2D

var player_scene: PackedScene = preload("res://scenes/player.tscn") 
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = player_scene.instantiate() as CharacterBody2D
	player.position = Global.get_pixel_from_grid(Vector2i(0,0))
	add_child(player)
	var test_enemy = enemy_scene.instantiate() as CharacterBody2D
	add_child(test_enemy)
