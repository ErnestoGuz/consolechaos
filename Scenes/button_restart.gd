extends Button

@export_file var restart_scene : String :
	set(value):
		if value == null:
			return
			
		restart_scene = value

func _ready() -> void:
	pressed.connect(_on_pressed)
	
	if not restart_scene:
		push_error("No restart scene set on loading [RestartGameButton]")

func _on_pressed():
	get_tree().change_scene_to_file(restart_scene)
