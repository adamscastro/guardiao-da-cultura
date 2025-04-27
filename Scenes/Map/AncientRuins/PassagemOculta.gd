extends StaticBody2D

@onready var col := get_node_or_null("CollisionShape2D")
@onready var visual := get_node_or_null("TileMapLayer")
@onready var detector := get_node_or_null("Detector")

func _ready():
	# Estado inicial: passagem visível e colidível (fechada)
	if col:
		col.disabled = false
	if visual:
		visual.visible = true

	# Conecta os sinais do detector, se existir
	if detector:
		detector.connect("area_entered", Callable(self, "_on_area_entered"))
		detector.connect("area_exited", Callable(self, "_on_area_exited"))

		# Aguarda um frame e checa se a LuzTupa já está sobreposta
		call_deferred("_verificar_entrada_inicial")

func _verificar_entrada_inicial():
	if not detector:
		return

	for area in detector.get_overlapping_areas():
		_on_area_entered(area)

func _on_area_entered(area):
	if area.name == "LuzTupa" and "Tupa" in BlessingManager.bencaos_ativas:
		if col:
			col.set_deferred("disabled", true)
		if visual:
			visual.visible = false

func _on_area_exited(area):
	if area.name == "LuzTupa":
		if col:
			col.set_deferred("disabled", false)
		if visual:
			visual.visible = true
