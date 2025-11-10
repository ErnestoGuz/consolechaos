extends Node2D

var puzzles_completed := 0
@onready var counter_label: Label = $UI/PuzzleCounter

func _ready():
	update_counter()

func increment_puzzle_count():
	puzzles_completed += 1
	update_counter()

func update_counter():
	counter_label.text = "Rompecabezas resueltos: %d" % puzzles_completed
