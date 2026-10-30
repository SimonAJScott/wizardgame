extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$"num enemies left".text = "num enemies left: " + str(Global.current_num_enemies)
	$gold.text = "Gold: " + str(get_tree().get_nodes_in_group("player")[0].get_gold())
