extends Node2D

enum State { EXPLORACAO, FUGA }
var state: State = State.EXPLORACAO

@onready var totem      = $Totem
@onready var trigger    = $StartTrigger
@onready var tilesFundo = $Tiles/Fundo
@onready var barrier_shape = $Collision/Passagem
@onready var camera     = $CharacterBody2D/Camera2D
@onready var maria      = $MariaCaninana
@onready var endtrigger = $EndTrigger

func _ready():
	# Conecta os sinais
	totem.connect("totem_ativado", Callable(self, "_on_totem_ativado"))
	maria.connect("player_caught", Callable(self, "_on_player_caught"))
	
	
	# Começa com Maria escondida e trigger desligado
	maria.visible = false
	maria.perseguindo = false

func _on_totem_ativado():
	print("➤ Totem ativado: liberando caminho")
	tilesFundo.z_index = -1
	barrier_shape.disabled = true
	camera.start_shake(5.0, 10.0)
	
	trigger.connect("body_entered", Callable(self, "_on_start_trigger_body_entered"))
	trigger.monitoring = true
	
	endtrigger.connect("body_entered", Callable(self, "_on_end_trigger_body_entered"))
	endtrigger.monitoring = true

func _on_start_trigger_body_entered(body):
	if body.is_in_group("player") and state == State.EXPLORACAO:
		state = State.FUGA
		trigger.queue_free() 

		print("➤ StartTrigger ativado: Maria desperta!")
		# Spawn e início da perseguição
		maria.global_position = Vector2(1295, 521)
		maria.visible = true
		maria.perseguindo = true
		
		tilesFundo.z_index = 0
		barrier_shape.set_deferred("disabled", false)
		camera.start_shake(5.0, 10.0)

func _on_end_trigger_body_entered(body):
	if body.is_in_group("player") and state == State.FUGA:
		state = State.EXPLORACAO
		endtrigger.queue_free()
		print("➤ Você escapou! Maria para de perseguir.")
		maria.perseguindo = false

func _on_player_caught():
	print("➤ Player pego! Reiniciando perseguição...")
	$CharacterBody2D.global_position = Vector2(1460, 546)
	maria.global_position = Vector2(1295, 521)
	maria.perseguindo = true
