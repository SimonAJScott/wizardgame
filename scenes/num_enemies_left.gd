extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "num enemies left: " + str(Global.current_num_enemies)
