extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite

const SPEED = 300.0

func _physics_process(_delta):
	var dir: Vector2 = Input.get_vector("idle_izquierda_new", "idle_derecha_new", "idle_espalda_new", "idle_abajo_new")
	
	if dir != Vector2.ZERO:
		if dir.x != 0:
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
		animated_sprite.stop()
		animated_sprite.frame = 0  # opcional para volver al primer frame
	
	velocity = dir * SPEED
	move_and_slide()
	
	pass
