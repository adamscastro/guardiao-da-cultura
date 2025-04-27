extends Node

# 💡 Referência ao personagem principal
var player: Node = null

# 🗺️ Mapeamento das cenas das bênçãos
var bencao_scenes = {
	"Jaci": preload("res://Scenes/Character/Habilidades/Jaci.tscn"),
	"Tupa": preload("res://Scenes/Character/Habilidades/Tupa.tscn"),
	"Iara": preload("res://Scenes/Character/Habilidades/Iara.tscn")
}

# 🧠 Instâncias ativas das habilidades
var bencaos_ativas = {}

# ⏳ Cooldowns ativos das bênçãos
var cooldowns = {}

# 📌 Configura o player
func set_player(p):
	player = p

# 🔁 Ativa uma bênção se estiver desbloqueada e fora do cooldown
func ativar_bencao(nome: String) -> void:
	# Para Tupa: ignora o cooldown
	if nome != "Tupa":
		if cooldowns.has(nome) and cooldowns[nome] > 0:
			print("Aguardando cooldown:", nome)
			return

	# Verifica se está desbloqueada
	if not PlayerData.tem_bencao(nome):
		print("Bênção ainda não desbloqueada:", nome)
		return

	# Verifica se já está ativa
	if bencaos_ativas.has(nome):
		print("Bênção já está ativa:", nome)
		return

	# Instancia a cena da bênção
	var cena_bencao = bencao_scenes.get(nome, null)
	if cena_bencao:
		var instancia = cena_bencao.instantiate()
		if player:
			player.get_node("Habilidades").add_child(instancia)
		else:
			get_tree().current_scene.add_child(instancia)
		bencaos_ativas[nome] = instancia
		print("Bênção ativada:", nome)

# ❌ Desativa uma bênção ativa manualmente
func desativar_bencao(nome: String) -> void:
	if bencaos_ativas.has(nome):
		bencaos_ativas[nome].queue_free()
		bencaos_ativas.erase(nome)
		print("Bênção desativada:", nome)

# 🔄 Desativa todas as bênçãos ativas
func desativar_todas() -> void:
	for nome in bencaos_ativas.keys():
		bencaos_ativas[nome].queue_free()
	bencaos_ativas.clear()
	print("Todas as bênçãos foram desativadas.")

# ⏳ Iniciar cooldown de uma bênção
func iniciar_cooldown(nome: String) -> void:
	# Para Tupa: não iniciar cooldown
	if nome == "Tupa":
		return

	var nivel = PlayerData.get_nivel_bencao(nome)
	var lista = PlayerData.bencao_cooldowns.get(nome, [5.0])
	var tempo = lista[min(nivel, lista.size() - 1)]

	cooldowns[nome] = tempo

	var t = Timer.new()
	t.wait_time = tempo
	t.one_shot = true
	t.connect("timeout", func():
		cooldowns.erase(nome)
		t.queue_free()
		print("Cooldown finalizado para:", nome)
	)
	add_child(t)
	t.start()
