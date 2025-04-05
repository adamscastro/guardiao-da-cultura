extends Node2D

var player
var vitoria_regia
var efeito_agua
var nivel = 0


func _ready():
	player = get_parent().get_parent()
	nivel = PlayerData.get_nivel_bencao("Iara")

	# Ativa imunidade à água
	player.imune_agua = true

	if has_node("EfeitoVisual"):
		$EfeitoVisual.visible = false
		$EfeitoAgua.visible = false

	
	# Salva o ponto atual como último seguro
	player.ultimo_ponto_seguro = player.global_position

	# Cria sprite da vitória-régia e posiciona no pé do personagem
	vitoria_regia = Sprite2D.new()
	vitoria_regia.texture = preload("res://Assets/Objects/vitoria-regia.png")  # ajuste o caminho se necessário
	vitoria_regia.z_index = -1
	vitoria_regia.scale = Vector2(0.06, 0.06)
	player.add_child(vitoria_regia)
	vitoria_regia.position = Vector2(0, 15)
	vitoria_regia.visible = false  # começa invisível
	
	efeito_agua = $EfeitoAgua
	efeito_agua.z_index = -2
	efeito_agua.position = Vector2(0,17)
	efeito_agua.modulate = Color(0.549, 0.855, 0.914, 0.596)
	efeito_agua.scale = Vector2(0.8, 0.8)
	
	

	# Tempo baseado no nível da bênção
	var duracoes = PlayerData.bencao_duracoes.get("Iara", [5.0])
	$Timer.wait_time = duracoes[min(nivel, duracoes.size() - 1)]
	$Timer.start()
	
	


@warning_ignore("unused_parameter")
func _process(delta):
	if player and vitoria_regia:
		var esta_na_agua = false
		for area in get_tree().get_nodes_in_group("agua_toxica"):
			if area.has_method("get_overlapping_bodies") and area.get_overlapping_bodies().has(player):
				esta_na_agua = true
				break
		vitoria_regia.visible = esta_na_agua
		if esta_na_agua:
			$EfeitoAgua.visible = true
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("iara_efeito_agua")
		else:
			$EfeitoAgua.visible = false

func _on_timer_timeout():
	player.imune_agua = false

	# Remove sprite da vitória-régia
	if vitoria_regia and vitoria_regia.is_inside_tree():
		vitoria_regia.queue_free()

	# Verifica se ainda está em água tóxica
	var em_agua_toxica = false
	for area in get_tree().get_nodes_in_group("agua_toxica"):
		if area is Area2D and area.get_overlapping_bodies().has(player):
			em_agua_toxica = true
			break

	if em_agua_toxica:
		player.global_position = player.ultimo_ponto_seguro
		player.travado = true
		print("Iara salvou você da água tóxica.")

		# Só mostra o efeito se estiver na água e o node existir
		if has_node("EfeitoVisual"):
			var efeito = $EfeitoVisual
			efeito.visible = true
			efeito.scale = Vector2(0.4, 0.4)
			efeito.modulate.a = 0.5
			$AnimationPlayer.play("iara_efeito")

			# Timer para destravar o jogador
			var t = Timer.new()
			t.wait_time = 1.0
			t.one_shot = true
			t.connect("timeout", Callable(self, "_destravar_player").bind(player))
			add_child(t)
			t.start()
		else:
			player.travado = false

	else:
		BlessingManager.bencaos_ativas.erase("Iara")
		BlessingManager.iniciar_cooldown("Iara")
		queue_free()


func _destravar_player(p):
	if is_instance_valid(p):
		p.travado = false
	BlessingManager.bencaos_ativas.erase("Iara")
	BlessingManager.iniciar_cooldown("Iara")
	queue_free()
