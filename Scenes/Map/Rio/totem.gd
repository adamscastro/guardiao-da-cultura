extends Area2D

signal totem_ativado

var pode_interagir := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body is CharacterBody2D:
		pode_interagir = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		pode_interagir = false

func _process(delta):
	if pode_interagir and Input.is_action_just_pressed("interagir"):
		emit_signal("totem_ativado")
		pode_interagir = false 
