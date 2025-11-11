extends CharacterBody2D

@export var speed: float = 200.0

# Referencia al AnimatedSprite2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	# Movimiento con teclas de dirección (flechas o WASD)
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	# Aplicar velocidad
	velocity = input_vector * speed
	move_and_slide()

	# --- Control de animaciones ---
	if input_vector == Vector2.ZERO:
		sprite.stop()
	else:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				sprite.play("derecha")
			else:
				sprite.play("izquierda")
		else:
			if input_vector.y > 0:
				sprite.play("adelante")
			else:
				sprite.play("espaldas")
