extends Node

signal player_action_done
signal enemy_action_done
signal player_died

func on_player_action_done():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.action_move_towards_player()
	print("enemies acted")
	TurnManager.enemy_action_done.emit()
