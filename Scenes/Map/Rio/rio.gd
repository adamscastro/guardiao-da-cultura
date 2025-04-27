extends Node2D

func _ready():
	$Totem.connect("totem_ativado", Callable(self, "_quando_totem_ativado"))

func _quando_totem_ativado():
	print("Totem ativado")

	var terra_fundo = $Tiles/Fundo
	terra_fundo.z_index = -1
	$Collision/Passagem.disabled = true  # desativa a colisão real

	$CharacterBody2D/Camera2D.start_shake(5.0, 10.0)
