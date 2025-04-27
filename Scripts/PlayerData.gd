# PlayerData.gd
extends Node

# 🌟 Bênçãos desbloqueadas (false = ainda não ativada)
var bencaos_desbloqueadas = {
	"Tupa": true,
	"Anhanga": true,
	"Iara": true,
	"Jaci": true,
	"Guaraci": false
}

# ⬆️ Nível atual de cada bênção (0 = não aprimorada)
var bencaos_nivel = {
	"Tupa": 0,
	"Anhanga": 0,
	"Iara": 0,
	"Jaci": 0,
	"Guaraci": 0
}

# Duração por nível
var bencao_duracoes = {
	"Jaci": [4.0, 6.0, 8.0],
	"Anhanga": [4.0, 6.0, 8.0],
	"Iara": [5.0, 7.0, 9.0],
	"Tupa": [4.0, 6.0, 8.0]
}

# Cooldown por nível
var bencao_cooldowns = {
	"Jaci": [10.0, 6.0, 4.0],
	"Anhanga": [12.0, 9.0, 6.0],
	"Iara": [10.0, 7.0, 5.0],
	"Tupa": [10.0, 7.0, 5.0]
}



# 🧠 Quantidade total de Ecos de Memória
var ecos_de_memoria = 0

# 🔓 Desbloqueia uma bênção
func desbloquear_bencao(nome: String) -> void:
	if bencaos_desbloqueadas.has(nome):
		bencaos_desbloqueadas[nome] = true

# ⬆️ Aumenta o nível de uma bênção (se desbloqueada)
func upgrade_bencao(nome: String) -> void:
	if bencaos_desbloqueadas.get(nome, false):
		bencaos_nivel[nome] += 1

# 📉 Gasta Ecos de Memória (se houver)
func gastar_ecos(qtd: int) -> bool:
	if ecos_de_memoria >= qtd:
		ecos_de_memoria -= qtd
		return true
	return false

# 🔍 Verifica se o jogador tem uma bênção desbloqueada
func tem_bencao(nome: String) -> bool:
	return bencaos_desbloqueadas.get(nome, false)

# 🔢 Retorna o nível atual de uma bênção
func get_nivel_bencao(nome: String) -> int:
	return bencaos_nivel.get(nome, 0)

# ➕ Adiciona Ecos de Memória
func adicionar_ecos(qtd: int) -> void:
	ecos_de_memoria += qtd
