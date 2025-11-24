extends CharacterBody2D

@export var speed: float = 150.0
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_parent().get_node("Jugador")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # ✅ animaciones del enemigo

func _ready():
	navigation_agent_2d.path_desired_distance = 8.0
	navigation_agent_2d.target_desired_distance = 8.0
	navigation_agent_2d.max_speed = speed
	$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not player:
		return

	navigation_agent_2d.target_position = player.global_position

	if not navigation_agent_2d.is_navigation_finished():
		var next_position = navigation_agent_2d.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * speed

		# ✅ Animar según la dirección del movimiento
		if abs(direction.x) > abs(direction.y):
			# Movimiento horizontal
			if direction.x > 0:
				sprite.play("derecha")
			else:
				sprite.play("new_animation")
		else:
			# Movimiento vertical
			if direction.y > 0:
				sprite.play("espaldas")
			  

	else:
		velocity = Vector2.ZERO
		sprite.stop()  # se detiene la animación al no moverse

	move_and_slide()

func _on_body_entered(body):
	if body == player:
		print("¡Jugador atrapado por colision ")
		velocity = Vector2.ZERO
		sprite.stop()
		#get_tree().change_scene_to_file("res://nivel2/GameOver.tscn")
