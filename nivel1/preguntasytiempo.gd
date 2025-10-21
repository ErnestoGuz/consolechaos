extends CanvasLayer
# Variables
var tiempo = 60  # segundos
var pregunta_actual = ""
var a = 0
var b = 0

@onready var tiempo_label = $TiempoLabel
@onready var pregunta_label = $PreguntaLabel

func _ready():
	generar_pregunta()
	actualizar_hud()
	# Timer para disminuir tiempo
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

# Actualiza el tiempo cada segundo
func _on_timer_timeout():
	tiempo -= 1
	if tiempo <= 0:
		tiempo = 0
		# Aquí puedes poner lógica de fin de juego
	actualizar_hud()

# Genera una pregunta de ejemplo (suma)
func generar_pregunta():
	a = randi() % 10 + 1
	b = randi() % 10 + 1
	pregunta_actual = str(a) + " + " + str(b) + " = ?"

# Actualiza los labels
func actualizar_hud():
	tiempo_label.text = "Tiempo: %d" % tiempo
	pregunta_label.text = pregunta_actual

# Función para verificar respuesta
func verificar_respuesta(respuesta):
	if respuesta == a + b:
		print("Correcto!")
		generar_pregunta()
		actualizar_hud()
	else:
		print("Incorrecto")
