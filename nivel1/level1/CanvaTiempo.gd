extends CanvasLayer

@onready var label_tiempo: Label = $Label  # Arrastra tu Label desde la escena
var total_time: float = 60.0
var time_left: float = total_time

func _ready():
	time_left = total_time
	update_label()
	set_process(true)

func _process(delta):
	if time_left > 0:
		time_left -= delta
		if time_left < 0:
			time_left = 0
			_on_time_up()
		update_label()

func update_label():
	label_tiempo.text = "Tiempo: " + str(int(time_left))

func _on_time_up():
	print("¡Tiempo terminado!")
	# Instancia la escena Game Over
	var game_over_scene = load("res://Scenes/gamer_over.tscn").instantiate()
	get_tree().current_scene.add_child(game_over_scene)
	set_process(false)  # Opcional: detener el HUD
