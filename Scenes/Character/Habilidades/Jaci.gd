extends Node2D

var velocidade_original = 0.0

func _ready():
	var player = get_parent().get_parent()
	velocidade_original = player.speed
		
	# Ativar furtividade
	player.modulate.a = 0.3
	player.speed = velocidade_original * 0.5
	
	$AnimationPlayer.play("efeito_jaci")

	# Duração por nível puxada do PlayerData
	var nivel = PlayerData.get_nivel_bencao("Jaci")
	var tempo_por_nivel = PlayerData.bencao_duracoes.get("Jaci", [4.0])
	var tempo = tempo_por_nivel[min(nivel, tempo_por_nivel.size() - 1)]
	
	$Timer.wait_time = tempo
	$Timer.start()

func _on_timer_timeout() -> void:
	var player = get_parent().get_parent()
	player.modulate.a = 1.0
	player.speed = velocidade_original

	BlessingManager.bencaos_ativas.erase("Jaci")
	BlessingManager.iniciar_cooldown("Jaci")
	queue_free()
