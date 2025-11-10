extends Node2D

var puzzles_completed := 0
@onready var counter_label: Label = $UI/PuzzleCounter
@onready var cam: Camera2D = $Camera2D
@onready var player: Node2D = $Jugador


var follow_player:= true
func _process(delta):
	if follow_player and cam:
		cam.position = player.global_position

func focus_on_puzzle(puzzle: Node2D):
	if puzzle == null : 
		print("PUZZLE NULL ")
		return
	follow_player= false
	var target:= puzzle.get_node_or_null("punto")
	if target == null:
		target = puzzle 
		
	var tween:= create_tween()
	tween.tween_property(cam, "position", target.global_position, 0.5)
	tween.tween_property(cam, "zoom", Vector2(1,1), 0.5)
	
func focus_on_player():
	follow_player = true
	var tween := create_tween()
	tween.tween_property(cam, "zoom", Vector2(1,1), 0.5)

func _ready():
	update_counter()
	
func increment_puzzle_count():
	puzzles_completed += 1
	update_counter()

func update_counter():
	counter_label.text = "Rompecabezas resueltos: %d" % puzzles_completed
