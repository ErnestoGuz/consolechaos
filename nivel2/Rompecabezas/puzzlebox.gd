extends Node2D

@export var puzzle_scene: PackedScene  # Aquí asignarás SlidePuzzle.tscn
@export var puzzle_image: Texture2D    # Imagen personalizada para esta caja

@onready var player = get_node("/root/Main/Jugador")

func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name != "Jugador":
		return

	var puzzle_instance = puzzle_scene.instantiate()
	puzzle_instance.image = puzzle_image
	puzzle_instance.visible = true

	# Conectar señal para reactivar al jugador cuando se resuelva
	puzzle_instance.puzzle_completed.connect(_on_puzzle_completed)

	# Agregar el puzzle al escenario principal
	get_tree().current_scene.add_child(puzzle_instance)
	await get_tree().process_frame
	get_node("/root/Main").focus_on_puzzle(puzzle_instance)

	# Desactivar al jugador
	player.set_process(false)
	player.set_physics_process(false)

func _on_puzzle_completed():
	player.set_process(true)
	player.set_physics_process(true)
	
	var main= get_node("/root/Main")
	main.increment_puzzle_count()
