extends CharacterBody2D

const Speed = 25
const maxspeed = 50


@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer

var motion = Vector2()

func _physics_process(delta):
	
	var friction = false
	
	if Input.is_action_pressed("idle_derecha_new")
		sprite.flip_h = false
		animationPlayer.play("adelante")
		motion.x = max(motion.x+Speed,maxspeed)
	
	
