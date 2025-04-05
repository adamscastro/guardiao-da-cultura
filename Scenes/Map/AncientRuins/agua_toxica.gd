extends StaticBody2D

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if player and "imune_agua" in player:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = player.imune_agua
				
