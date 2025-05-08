# MariaCaninana.gd
extends CharacterBody2D

signal player_caught

@export var velocidade := 80
@export var gravidade := 300
@export var velocidade_max := 200.0

@export var oscilacao_amplitude := 12.0
@export var oscilacao_frequencia := 4.0

var perseguindo: bool = false
@onready var jogador: CharacterBody2D = get_parent().get_node("CharacterBody2D")
@onready var detector: Area2D = $Detector

var velocidade_vertical := 0.0
var tempo := 0.0

func _ready():
	# conecta o Detector para avisar quando a Maria alcançar o jogador
	detector.connect("body_entered", Callable(self, "_on_detector_body_entered"))

func _on_detector_body_entered(body):
	if body == jogador and perseguindo:
		emit_signal("player_caught")

func _physics_process(delta):
	tempo += delta

	# aplica gravidade vertical
	if not is_on_floor():
		velocidade_vertical += gravidade * delta
	else:
		velocidade_vertical = 0.0

	if perseguindo and jogador:
		var direcao = (jogador.global_position - global_position).normalized()
		velocity.x = direcao.x * velocidade
		velocity.y = clamp(velocidade_vertical, -velocidade_max, velocidade_max)

		# flip horizontal do sprite
		$Sprite2D.flip_h = direcao.x < 0

		# movimento serpentino (ondulação)
		var oscilacao = sin(tempo * oscilacao_frequencia) * oscilacao_amplitude
		position.y += oscilacao * delta
	else:
		velocity = Vector2.ZERO

	move_and_slide()
