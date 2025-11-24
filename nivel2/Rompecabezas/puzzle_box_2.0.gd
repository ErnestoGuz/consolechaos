extends StaticBody2D

signal solicitar_focus_puzzle(puzzle: Node)
signal puzzle_cerrado()

@export var puzzle_scene: PackedScene
var puzzle_instance: Node
var usada := false

func _ready():
	
	$Area2D.body_entered.connect(_on_body_entered)
	$Label.visible = false

func _on_body_entered(body):
	print("Area2D detectó:", body.name, " Grupo(player):", body.is_in_group("player"))
	if body.is_in_group("player") and not usada:
		_abrir_puzzle()

func _abrir_puzzle():
	if puzzle_scene == null:
		push_warning("Puzzle no asignado en CajaInteractiva")
		return
	puzzle_instance = puzzle_scene.instantiate()
	get_tree().root.add_child(puzzle_instance)
	if puzzle_instance.has_signal("puzzle_completed"):
		puzzle_instance.connect("puzzle_completed", _on_puzzle_completado)
	else:
		push_warning("La escena de puzzle no tiene señal 'puzzle_completed'")
	emit_signal("solicitar_focus_puzzle", puzzle_instance)

func _on_puzzle_completado():
	usada = true
	$Sprite2D.texture = preload("res://nivel2/images/box_open.png")
	$Label.text = "Caja usada"
	$Label.visible = true
	emit_signal("puzzle_cerrado")
