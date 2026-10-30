extends CanvasLayer

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		get_tree().change_scene_to_file('res://scenes/game.tscn')
		LevelManager.death_to_game.emit()
