extends CharacterBody2D

@export var velocidade := 80
@export var gravidade := 300
@export var velocidade_max := 200.0

@export var oscilacao_amplitude := 12.0     # Quanto ela oscila
@export var oscilacao_frequencia := 4.0     # Velocidade da oscilação

var jogador: CharacterBody2D = null
var velocidade_vertical := 0.0
var tempo := 0.0  # usado para movimento serpentino


func _ready():
	jogador = get_parent().get_node("CharacterBody2D")  # ajuste o caminho se necessário

func _physics_process(delta):
	tempo += delta

	if not is_on_floor():
		velocidade_vertical += gravidade * delta
	else:
		velocidade_vertical = 0.0

	if jogador:
		var direcao = (jogador.global_position - global_position).normalized()
		
		velocity.x = direcao.x * velocidade
		velocity.y = clamp(velocidade_vertical, -velocidade_max, velocidade_max)

		# FLIP baseado na direção X
		if direcao.x < 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false

		# Movimento serpentino
		var oscilacao := sin(tempo * oscilacao_frequencia) * oscilacao_amplitude
		position.y += oscilacao * delta
	else:
		velocity = Vector2.ZERO

	move_and_slide()
