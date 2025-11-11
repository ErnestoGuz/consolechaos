extends Node2D

var puzzles_completed := 0
@onready var counter_bar: HBoxContainer = $UI/PuzzleCounter
@export var max_pieces := 5 
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
	for i in range(max_pieces):
		var piece = counter_bar.get_child(i)
		if i < puzzles_completed:
			piece.texture = preload("res://nivel2/images/barra-fullpreview.png")
		else:
			piece.texture = preload("res://nivel2/images/Barra-Emptypreview.png")
		
	
#oculta y muestra el label 
func hide_counter():
	counter_bar.visible = false

func show_counter():
	counter_bar.visible = true
