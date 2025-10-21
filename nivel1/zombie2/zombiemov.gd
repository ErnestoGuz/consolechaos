extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite
@onready var label = $Label
@onready var jugador = null  # Se buscará en _ready()

const SPEED = 80.0
var respuesta: String = ""  # La respuesta que este zombie representa

func _ready():
	randomize()
	# Buscamos al jugador en el grupo "player"
	jugador = get_tree().get_first_node_in_group("player")
	label.text = respuesta

func _physics_process(delta):
	if jugador == null:
		return

	# Dirección hacia el jugador
	var dir = jugador.global_position - global_position
	if dir.length() > 0:
		dir = dir.normalized()
		velocity = dir * SPEED
		move_and_slide()

		# Animación según dirección
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				animated_sprite.play("idle_derecha_new")
			else:
				animated_sprite.play("idle_izquierda_new")
		else:
			if dir.y > 0:
				animated_sprite.play("idle_abajo_new")
			else:
				animated_sprite.play("idle_espalda_new")
	else:
		velocity = Vector2.ZERO
		animated_sprite.stop()
