extends CharacterBody2D

@onready var area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # 👈 Aquí usamos AnimatedSprite2D

var activo = false
var jugador = null
var velocidad = 190

func _ready():
	# Conectamos la señal cuando el enemigo toca algo
	area.body_entered.connect(_on_area_body_entered)
	
	# Si tienes animación "caminar", la reproducimos desde el inicio
	if animated_sprite.sprite_frames.has_animation("caminar"):
		animated_sprite.play("caminar")

func _physics_process(delta):
	if activo and jugador:
		var direccion = (jugador.global_position - global_position).normalized()
		velocity = direccion * velocidad
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func _on_area_body_entered(body):
	# Si el enemigo toca al jugador
	if body.is_in_group("Player"):
		# Reproducimos una animación (por ejemplo “caminar” o “ataque” si la tienes)
		if animated_sprite.sprite_frames.has_animation("caminar"):
			animated_sprite.play("caminar")
		
		# Espera 0.3 segundos antes de cambiar de escena (para ver la animación)
		await get_tree().create_timer(0.3).timeout
		
		get_tree().change_scene_to_file("res://nivel3/gameover/game_over_v_2.tscn")
