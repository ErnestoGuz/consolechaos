extends Control

func _on_play_sound_effect_btn_pressed() -> void:
	$sound_effect.play()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
