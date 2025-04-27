extends Node2D

@onready var camera := get_tree().get_first_node_in_group("player").get_node("Camera2D")
@onready var particles1 := $CPUParticles2D
@onready var particles2 := $CPUParticles2D2
@onready var player := get_tree().get_first_node_in_group("player")
@onready var color_rect := $ColorRect
@onready var canvas_modulate := get_tree().get_root().get_node("AncientRuins/Véu/CanvasModulate")

var tween: Tween = null

func _ready():
	print("Véu iniciado!")
	particles1.emitting = true
	particles2.emitting = true

	color_rect.visible = true
	canvas_modulate.visible = true

	color_rect.modulate.a = 1.0
	canvas_modulate.modulate.a = 1.0

func _process(delta):
	if camera:
		position = camera.global_position

	if BlessingManager.bencaos_ativas.has("Tupa"):
		desaparecer_veu()
	else:
		reaparecer_veu()

func desaparecer_veu():
	if tween and tween.is_running():
		return

	tween = create_tween()

	# CanvasModulate desaparece mais rápido (ex: 0.6s)
	tween.tween_property(canvas_modulate, "modulate:a", 0.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# ColorRect desaparece normal (ex: 1.0s)
	tween.parallel().tween_property(color_rect, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func reaparecer_veu():
	if tween and tween.is_running():
		return

	tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)  # ColorRect volta em 0.7s
	tween.parallel().tween_property(canvas_modulate, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)  # CanvasModulate volta em 1.2s
