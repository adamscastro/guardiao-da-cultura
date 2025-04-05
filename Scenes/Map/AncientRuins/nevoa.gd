extends Node2D

@onready var camera = get_tree().get_first_node_in_group("player").get_node("Camera2D")
@onready var particles1 = $CPUParticles2D
@onready var particles2 = $CPUParticles2D2
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	# Inicializa com a névoa ativada
	particles1.emitting = true
	particles2.emitting = true
	color_rect.visible = true
	color_rect.modulate.a = 1.0

func _process(delta):
	# Faz a névoa seguir a câmera
	if camera:
		position = camera.global_position
