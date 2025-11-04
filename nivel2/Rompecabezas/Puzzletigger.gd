extends Node2D

@export var SlidePuzzle: PackedScene
var puzzle_instance: CanvasLayer

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jugador" and not puzzle_instance:
		puzzle_instance = SlidePuzzle.instantiate()
		get_tree().root.add_child(puzzle_instance)  # Agrega al árbol de UI

		# Centrar el Control dentro del CanvasLayer
		var screen_size = get_viewport().get_visible_rect().size
		puzzle_instance.get_node("Control").position = screen_size / 2

		# Conectar señal para cerrar automáticamente
		puzzle_instance.puzzle_completed.connect(_on_puzzle_completed)

func _on_puzzle_completed():
	puzzle_instance.queue_free()
	puzzle_instance = null
