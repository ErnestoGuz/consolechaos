extends Node2D

var puzzles_completed := 0
@onready var counter_label: Label = $UI/PuzzleCounter
@onready var puzzle_icon: TextureRect = $UI/PuzzleIcon
@onready var cam: Camera2D = $Camera2D
@onready var player: Node2D = $Jugador

var follow_player := true

func _ready():
	var cajas := get_tree().get_nodes_in_group("caja_interactiva")
	for caja in cajas:
		_conectar_caja(caja)

func _process(delta):
	if follow_player and cam:
		cam.position = player.global_position

func _conectar_caja(caja: Node):
	if caja.has_signal("solicitar_focus_puzzle"):
		caja.connect("solicitar_focus_puzzle", Callable(self, "_on_solicitar_focus_puzzle"))
	if caja.has_signal("puzzle_cerrado"):
		caja.connect("puzzle_cerrado", Callable(self, "_on_puzzle_cerrado"))

func _on_solicitar_focus_puzzle(puzzle: Node):
	follow_player = false
	focus_on_puzzle(puzzle)

func _on_puzzle_cerrado():
	focus_on_player()
	increment_puzzle_count()

func focus_on_puzzle(puzzle: Node2D):
	if puzzle == null:
		print("PUZZLE NULL")
		return
	follow_player = false
	var target := puzzle.get_node_or_null("punto")
	if target == null:
		target = puzzle
	var tween := create_tween()
	tween.tween_property(cam, "position", target.position, 0.5)
	tween.tween_property(cam, "zoom", Vector2(1,1), 0.5)

func focus_on_player():
	follow_player = true
	var tween := create_tween()
	tween.tween_property(cam, "zoom", Vector2(1,1), 0.5)

func increment_puzzle_count():
	puzzles_completed += 1
	update_counter()

func update_counter():
	counter_label.text = "Rompecabezas resueltos: %d" % puzzles_completed

func hide_counter():
	$UI/PuzzleCounter.visible = false
	$UI/PuzzleIcon.visible = false

func show_counter():
	$UI/PuzzleCounter.visible = true
	$UI/PuzzleIcon.visible = true
