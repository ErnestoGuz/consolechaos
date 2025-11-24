extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var speed = 600
var direction = -1  # 1 = hacia abajo, -1 = hacia arriba

func _ready():
	area.body_entered.connect(_on_area_body_entered)
	velocity.y = speed * direction
	animated_sprite.play("walk")

func _next_to_top_wall() -> bool:
	return $Arriba.is_colliding()

func _next_to_bottom_wall() -> bool:
	return $Abajo.is_colliding()

func _flip():
	# Si toca arriba o abajo, cambia dirección
	if _next_to_top_wall() or _next_to_bottom_wall():
		direction *= -1
		velocity.y = speed * direction
		animated_sprite.scale.y *= -1  # 🔹 voltea verticalmente el sprite

func _physics_process(delta):
	_flip()
	move_and_slide()

	if abs(velocity.y) > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("walk")

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		await get_tree().create_timer(0.3).timeout
		get_tree().change_scene_to_file("res://nivel3/gameover/game_over_v_2.tscn")
