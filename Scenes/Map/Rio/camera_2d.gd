extends Camera2D

var shake_strength := 0.0
var shake_decay := 5.0
var original_position := Vector2.ZERO

func _ready():
	original_position = position

func _process(delta):
	if shake_strength > 0:
		position = original_position + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		position = original_position

func start_shake(strength: float, decay: float = 5.0):
	shake_strength = strength
	shake_decay = decay
