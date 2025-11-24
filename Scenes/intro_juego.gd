extends Control

func _ready() -> void:
	var video_player = $VideoStreamPlayer
	video_player.finished.connect(_on_video_stream_player_finished)

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://Panel_Instrucciones/pantalla_instruccionesLevel1.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		get_tree().change_scene_to_file("res://Panel_Instrucciones/pantalla_instruccionesLevel1.tscn")


func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://Panel_Instrucciones/pantalla_instruccionesLevel1.tscn")
