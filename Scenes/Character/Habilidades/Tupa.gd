extends Node2D

var ativo: bool = false
var tween: Tween = null

func _ready():
	BlessingManager.bencaos_ativas["Tupa"] = self
	_desligar_visual()

func _process(delta):
	if Input.is_action_just_pressed("ativar_tupa"):
		ativo = not ativo
		if ativo:
			_ativar_visual()
		else:
			_desligar_visual()

func _ativar_visual():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	var luz = player.get_node_or_null("LuzTupa")
	var aura = player.get_node_or_null("Aura")

	if luz:
		luz.visible = false
		luz.monitoring = false

	if aura:
		aura.visible = false          # <— garantir que fica visível
		aura.enabled = false
		aura.scale = Vector2(1, 1)

		if tween:
			tween.kill()

		tween = create_tween()
		tween.tween_property(aura, "scale", Vector2(1.2, 1.2), 0.8) \
			 .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(aura, "scale", Vector2(1, 1), 0.8) \
			 .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.set_loops()

func _desligar_visual():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	var luz = player.get_node_or_null("LuzTupa")
	var aura = player.get_node_or_null("Aura")

	if luz:
		luz.visible = true
		luz.monitoring = true

	if aura:
		aura.visible = true       # <— ocultar também
		aura.enabled = true
		if tween:
			tween.kill()

func _exit_tree():
	BlessingManager.bencaos_ativas.erase("Tupa")
