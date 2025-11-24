# PuzzleBox.gd
extends Area2D

@export var box_id: String = ""
var used: bool = false

@onready var sprite := $Sprite2D
@onready var prompt := $Label

var player_in_range: bool = false

func _ready() -> void:
	# Consultar estado global al cargar
	used = PuzzleManager.is_box_used(box_id)
	_update_visual_state()
	prompt.visible = false
	# Conectar señales
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		_update_prompt()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		prompt.visible = false

func _process(_delta: float) -> void:
	# Acción de interacción (define "interact" en Input Map)
	if player_in_range and Input.is_action_just_pressed("interact"):
		_try_open_puzzle()

func _try_open_puzzle() -> void:
	if used:
		return
	# Deshabilitar interacción mientras el puzzle esté abierto
	set_monitoring(false)
	prompt.visible = false
	PuzzleManager.open_puzzle(self, box_id, _on_puzzle_completed, _on_puzzle_closed)

func _on_puzzle_completed() -> void:
	used = true
	PuzzleManager.mark_box_used(box_id)
	_update_visual_state()
	# Rehabilitar para detectar al jugador (pero ya no abrirá puzzle)
	set_monitoring(true)

func _on_puzzle_closed() -> void:
	# Si cerró sin completar, volver a permitir interacción
	if not used:
		set_monitoring(true)
		_update_prompt()

func _update_visual_state() -> void:
	if used:
		# Cambia tintado o frame para indicar “usada”
		sprite.modulate = Color(0.7, 0.7, 0.7, 1.0)
	else:
		sprite.modulate = Color(1, 1, 1, 1)

func _update_prompt() -> void:
	prompt.visible = player_in_range and not used
	prompt.text = "Pulsa E"
