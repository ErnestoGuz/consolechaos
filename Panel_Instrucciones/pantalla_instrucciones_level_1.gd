extends Control

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim_player.play("anim_player")
	# Espera 5 segundos y luego pasa al nivel
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://nivel1/level1/Level1Map.tscn")
