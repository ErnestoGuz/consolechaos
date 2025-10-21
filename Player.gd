extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta):
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("idle_espalda_new"):
		dir.y -=1
	if Input.is_action_pressed("idle_abajo_new"):
		dir.y +=1
	if Input.is_action_pressed("idle_derecha_new"):
		dir.x -=1
	if Input.is_action_pressed("idle_izquierda_new"):
		dir.x +=1
		
	velocity = dir.normalized() * speed
	move_and_slide()
