extends CharacterBody2D

const VELOCIDADE := 80
const FLUTUAR_LENTO := Vector2(0, 10)

var tempo_parado := 0.0
var tempo_para_flutuar := 0.5

@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D
@onready var bolhas := $Bolhas

var sprite_movimento := preload("res://Assets/Character/Aruan/aruan_serpente.png")
var sprite_idle := preload("res://Assets/Character/Aruan/aruan_serpente_idle.png")

func _physics_process(delta):
	var movimento = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		movimento.x += 1
	if Input.is_action_pressed("ui_left"):
		movimento.x -= 1
	if Input.is_action_pressed("ui_down"):
		movimento.y += 1
	if Input.is_action_pressed("ui_up"):
		movimento.y -= 1

	if movimento != Vector2.ZERO:
		tempo_parado = 0.0
		velocity = movimento.normalized() * VELOCIDADE

		# Flip horizontal
		if movimento.x != 0:
			sprite.flip_h = movimento.x > 0
			bolhas.position.x = 24 if movimento.x > 0 else -24  # ajusta posição da bolha
			bolhas.position.y = 4
			
		# Inclinação com compensação do flip
		var inclinacao = 0.0
		if movimento.y < 0:
			inclinacao = 30  # Subindo
		elif movimento.y > 0:
			inclinacao = -30 # Descendo

		if sprite.flip_h:
			inclinacao *= -1

		sprite.rotation_degrees = inclinacao

		# Troca para sprite de movimento
		if sprite.texture != sprite_movimento:
			sprite.texture = sprite_movimento

		# Velocidade normal da animação
		anim.speed_scale = 1.0

		if !anim.is_playing():
			anim.play("nadando")

		# Ativa as bolhas quando em movimento
		bolhas.emitting = true
	else:
		tempo_parado += delta
		if tempo_parado >= tempo_para_flutuar:
			velocity = FLUTUAR_LENTO
		else:
			velocity = Vector2.ZERO

		# Reset de rotação
		sprite.rotation_degrees = 0

		# Troca para sprite idle
		if sprite.texture != sprite_idle:
			sprite.texture = sprite_idle

		# Velocidade reduzida da animação
		anim.speed_scale = 0.7

		if !anim.is_playing():
			anim.play("nadando")


	move_and_slide()
