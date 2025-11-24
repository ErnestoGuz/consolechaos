extends CharacterBody2D
class_name zombie2_0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D  # Un Area2D con CollisionShape2D

var speed = 210
var player = null

func _ready():
	player = get_tree().get_nodes_in_group("personaje")[0]
	# Conectar la señal de colisión del área
	area.body_entered.connect(_on_area_body_entered)

func _process(delta: float) -> void:
	follow()
	update_animation()

func follow():
	if player != null:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()

func update_animation():
	if velocity == Vector2.ZERO:
		animated_sprite.stop()
		return
	
	var dir = velocity.normalized()
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("derecha")
		else:
			animated_sprite.play("izquierda")
	else:
		if dir.y > 0:
			animated_sprite.play("abajo")
		else:
			animated_sprite.play("arriba")

# Nueva función: detecta colisión con jugador
func _on_area_body_entered(body: Node):
	if body.is_in_group("personaje"):
		get_tree().change_scene_to_file("res://nivel1/level1/gameover/game_over_lv1.tscn") # Cierra la escena/juego
