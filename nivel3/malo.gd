extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var speed = 600
var direction = 1  # 1 = derecha, -1 = izquierda

func _ready():
	area.body_entered.connect(_on_area_body_entered)
	velocity.x = speed * direction
	
	# Reproduce una animación inicial
	animated_sprite.play("walk")

func _next_to_left_wall() -> bool:
	return $Izquierda.is_colliding()
	
func _next_to_right_wall() -> bool:
	return $Derecha.is_colliding()

func _flip():
	# Si toca una pared, invierte dirección
	if _next_to_right_wall() or _next_to_left_wall():
		direction *= -1
		animated_sprite.scale.x *= -1
		velocity.x = speed * direction

func _physics_process(delta):
	_flip()
	move_and_slide()
	
	# Si quieres cambiar animaciones según movimiento:
	if abs(velocity.x) > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("walk")

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.3).timeout  # Espera un poco para que se vea la animación
		get_tree().change_scene_to_file("res://nivel3/gameover/game_over_v_2.tscn")
