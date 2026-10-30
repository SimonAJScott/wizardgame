extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$"num enemies left".text = "num enemies left: " + str(Global.current_num_enemies)
	var player = get_tree().get_nodes_in_group("player")[0]
	$gold.text = "Gold: " + str(player.get_gold())
	$spell_1_rect/spell_1_title.text = player.spell_1.name
	if player.spell_1.current_cooldown > 0:
		$spell_1_rect/ready_rect.hide()
		$spell_1_rect/spell_1_cooldown.text = str(player.spell_1.current_cooldown)
	else:
		$spell_1_rect/ready_rect.show()
		$spell_1_rect/spell_1_cooldown.text = ""
