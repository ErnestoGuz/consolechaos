extends CharacterBody2D

enum State { PATROL, CHASE }
var state: State = State.PATROL

@export var speed: float = 200.0
@export var chase_speed: float = 200.0
@export var player_path: NodePath
var patrol_points: Array[Vector2] = []
@export var patrol_points_path: NodePath



@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision_area: Area2D = $visionArea

#var player_prev_pos: Vector2
var player: Node2D = null
var patrol_index: int = 0
#var last_dir := Vector2.DOWN  # Dirección por defecto mientras no detectemos movimiento

func _ready():
	if player_path == null:
		print("⚠️ No se ha asignado el Player en el inspector.")
		return

	player = get_node(player_path)
	#conecta las señales
	vision_area.body_entered.connect(_on_player_detected)
	vision_area.body_exited.connect(_on_player_lost)
	if patrol_points_path != NodePath():
		var points_parent = get_node(patrol_points_path)
		for child in points_parent.get_children():
			if child is Marker2D:
				patrol_points.append(child.global_position)
				print("🧭 Puntos de patrulla cargados:", patrol_points)


func _physics_process(delta:float)-> void:
	match state:
		State.PATROL:
			_patrol(delta)
			
		State.CHASE:
			_chase(delta)
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
		
		#-----PATRULLA
func _patrol(delta:float) -> void:
	var target= patrol_points[patrol_index]
	var direction = (target - global_position).normalized() 
	velocity  = direction * speed 
	move_and_slide()
	
	if global_position.distance_to(target) < 05.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
		print("🚶 Patrullando hacia:", patrol_points[patrol_index])

		
func _chase(delta:float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed * 1.2 
		move_and_slide()
		
func _on_player_detected(body: Node) -> void:
	if body == player:
		print("👀 Jugador detectado")
		state = State.CHASE

func _on_player_lost(body: Node) -> void:
	if body == player:
		print("🔍 Jugador perdido")
		state = State.PATROL
	
		
