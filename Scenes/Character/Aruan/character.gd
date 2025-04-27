extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 500.0
@export var friction = 500.0

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var input_direction = Vector2.ZERO
var last_direction = Vector2(0, 1) 
var current_animation = "parado_baixo"

var imune_agua = false
var ultimo_ponto_seguro = Vector2.ZERO

var travado = false



func _physics_process(delta):
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if input_direction != Vector2.ZERO:

		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
		last_direction = input_direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	update_animation()
	
	move_and_slide()
	
	if travado:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	

func update_animation():
	var new_animation = ""
	
	if input_direction != Vector2.ZERO:
		if input_direction.y > 0.5:  # Moving down
			if input_direction.x > 0.5:
				new_animation = "andar_baixo_diagonal_direito"
			elif input_direction.x < -0.5:
				new_animation = "andar_baixo_diagonal_esquerda"
			else:
				new_animation = "andar_baixo"
		elif input_direction.y < -0.5:  # Moving up
			if input_direction.x > 0.5:
				new_animation = "andar_cima_diagonal_direito"
			elif input_direction.x < -0.5:
				new_animation = "andar_cima_diagonal_esquerda"
			else:
				new_animation = "andar_cima"
		else:  # Moving horizontally
			if input_direction.x > 0:
				new_animation = "andar_direito"
			elif input_direction.x < 0:
				new_animation = "andar_esquerda"
	else:
		# Idle
		if last_direction.y > 0.5:  # Facing down
			if last_direction.x > 0.5:
				new_animation = "parado_baixo_diagonal_direito"
			elif last_direction.x < -0.5:
				new_animation = "parado_baixo_diagonal_esquerda"
			else:
				new_animation = "parado_baixo"
		elif last_direction.y < -0.5:  # Facing up
			if last_direction.x > 0.5:
				new_animation = "parado_cima_diagonal_direito"
			elif last_direction.x < -0.5:
				new_animation = "parado_cima_diagonal_esquerda"
			else:
				new_animation = "parado_cima"
		else:  # Facing horizontally
			if last_direction.x > 0:
				new_animation = "parado_direito"
			elif last_direction.x < 0:
				new_animation = "parado_esquerda"
			else:
				new_animation = "parado_baixo"  # Default if no direction
	
	# Only change animation if needed
	if new_animation != current_animation && new_animation != "":
		current_animation = new_animation
		animation_player.play(current_animation)
		
		
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):  
		BlessingManager.set_player(self)
		BlessingManager.ativar_bencao("Jaci")
		
	if Input.is_action_just_pressed("ativar_tupa"):  # Tecla que você definiu no InputMap
		BlessingManager.set_player(self)
		# Se já está ativa, desativa; senão, ativa
		if "Tupa" in BlessingManager.bencaos_ativas:
			BlessingManager.desativar_bencao("Tupa")
		else:
			BlessingManager.ativar_bencao("Tupa")


	if Input.is_action_just_pressed("ativar_iara"):  # Tecla I
		BlessingManager.set_player(self)
		BlessingManager.ativar_bencao("Iara")

		
	
