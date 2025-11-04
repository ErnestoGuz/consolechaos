extends StaticBody2D

@export var SlidePuzzle: PackedScene
var puzzle_instance: Node2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not puzzle_instance:
			puzzle_instance = SlidePuzzle.instantiate()
			get_tree().current_scene.add_child(puzzle_instance)
			puzzle_instance.global_position = global_position + Vector2(0, -100)  # Ajusta según tu diseño
	print("¡Clic detectado!")
