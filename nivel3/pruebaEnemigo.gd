extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D  # Un Area2D con CollisionShape2D

var speed = 210
var player = null

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	# Conectar la señal de colisión del área
	area.body_entered.connect(_on_area_body_entered)

func _process(delta: float) -> void:
	follow()

func follow():
	if player != null:
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
# Nueva función: detecta colisión con jugador
func _on_area_body_entered(body: Node):
	if body.is_in_group("Player"):
		get_tree().quit()  # Cierra la escena/juego
