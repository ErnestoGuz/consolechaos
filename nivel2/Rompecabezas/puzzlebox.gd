extends Node2D

@export var puzzle_scene: PackedScene  # Aquí asignarás SlidePuzzle.tscn
@export var puzzle_image: Texture2D    # Imagen personalizada para esta caja

@export var caja_cerrada: Texture2D
@export var caja_abierta: Texture2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var interact_label = $Label
@onready var sprite = $Sprite2D

var jugador_dentro: bool = false
var puzzle_instance

func _ready():
	sprite.texture = caja_cerrada
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Jugador entró en la caja")
		jugador_dentro = true
		interact_label.visible = true   # mostrar el mensaje

func _on_body_exited(body):
	if body.is_in_group("Player"):
		print("Jugador salió de la caja")
		jugador_dentro = false
		interact_label.visible = false  # ocultar el mensaje

func _process(delta):
	if jugador_dentro and Input.is_action_just_pressed("interact"):
		abrir_puzzle()

func abrir_puzzle():
	if puzzle_instance: # si ya hay puzzle abierto, no abrir otro
		return

	puzzle_instance = puzzle_scene.instantiate()
	puzzle_instance.image = puzzle_image
	puzzle_instance.visible = true

	# Conectar señal para reactivar al jugador cuando se resuelva
	puzzle_instance.puzzle_completed.connect(_on_puzzle_completed)

	# Agregar el puzzle al escenario principal
	get_tree().current_scene.add_child(puzzle_instance)

	await get_tree().process_frame
	var main = get_tree().current_scene
	main.focus_on_puzzle(puzzle_instance)
	main.hide_counter() # oculta el contador

	# Desactivar al jugador
	player.set_process(false)
	player.set_physics_process(false)
	interact_label.visible = false   # ocultar el mensaje cuando se abre el puzzle

func _on_puzzle_completed():
	player.set_process(true)
	player.set_physics_process(true)
	
	var main = get_node("/root/Main")
	main.increment_puzzle_count()
	# Cambiar la imagen de la caja a abierta
	sprite.texture = caja_abierta
	puzzle_instance = null
