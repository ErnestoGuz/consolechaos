extends CharacterBody2D

@export var speed: float = 200.0
@export var follow_distance: float = 25.0  # más cerca
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var player_path: NodePath

var player_prev_pos: Vector2
var player: Node = null
var last_dir := Vector2.DOWN  # Dirección por defecto mientras no detectemos movimiento

func _ready():
	if player_path == null:
		print("⚠️ No se ha asignado el Player en el inspector.")
		return

	player = get_node(player_path)
	if player:
		# guardamos la posición inicial
		player_prev_pos = player.global_position

		# Esperamos un frame para poder detectar la dirección real inicial del jugador
		await get_tree().process_frame

		# recalculamos después del primer frame
		var new_pos = player.global_position
		var initial_dir = new_pos - player_prev_pos

		if initial_dir.length() > 0.01:
			last_dir = initial_dir.normalized()
		# actualizamos player_prev_pos para el loop
		player_prev_pos = player.global_position

		# Ahora sí colocamos al payaso justo detrás del jugador según la dirección detectada
		global_position = player.global_position - last_dir * follow_distance
		print("🧟 Payaso colocado detrás del jugador. last_dir =", last_dir)


func _physics_process(delta):
	if player == null:
		return

	# Detectar movimiento del jugador (más sensible: umbral pequeño)
	var player_dir = player.global_position - player_prev_pos
	if player_dir.length() > 0.01:
		last_dir = player_dir.normalized()
	player_prev_pos = player.global_position

	# Posición objetivo detrás del jugador
	var target_pos = player.global_position - last_dir * follow_distance

	# Movimiento hacia la posición detrás del jugador
	var to_target = target_pos - global_position
	var distance = to_target.length()

	if distance > 1.5:
		velocity = to_target.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# --- Animaciones (mantengo sus nombres) ---
	if velocity != Vector2.ZERO:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("derecha")
			else:
				animated_sprite.play("Izquierda")
		else:
			animated_sprite.play("espaldas")
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0
