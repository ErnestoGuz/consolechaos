extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://nivel3/Nivel3.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://src/sample_scene/sample_scene.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
