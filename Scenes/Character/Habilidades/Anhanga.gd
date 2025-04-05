extends Node2D

var veu
var passagens_ocultas = []
var nivel = 0

func _ready():
	nivel = PlayerData.get_nivel_bencao("Anhanga")
	
	# ⏱️ Duração da bênção por nível (do PlayerData)
	var tempo_por_nivel = PlayerData.bencao_duracoes.get("Anhanga", [5.0])
	var tempo = tempo_por_nivel[min(nivel, tempo_por_nivel.size() - 1)]
	
	# Pega o véu na cena
	veu = get_tree().get_first_node_in_group("veu")
	
	if veu:
		# Desativa efeitos visuais
		veu.particles1.emitting = false
		veu.particles2.emitting = false
		veu.color_rect.visible = false
		veu.animation_player.play("fade_out")
	
	# Oculta e desativa colisão das passagens
	passagens_ocultas = get_tree().get_nodes_in_group("passagens_ocultas")
	for p in passagens_ocultas:
		p.visible = false
		var collision = p.get_node("CollisionShape2D")
		if collision:
			collision.disabled = true

	# Inicia o Timer
	$Timer.wait_time = tempo
	$Timer.start()

func _on_Timer_timeout():
	# Reativa o véu
	if veu:
		veu.particles1.emitting = true
		veu.particles2.emitting = true
		veu.color_rect.visible = true
		veu.animation_player.play("fade_in")
	
	# Reexibe passagens e colisões
	for p in passagens_ocultas:
		p.visible = true
		var collision = p.get_node("CollisionShape2D")
		if collision:
			collision.disabled = false
	
	# Finalização
	BlessingManager.bencaos_ativas.erase("Anhanga")
	BlessingManager.iniciar_cooldown("Anhanga")
	queue_free()
