extends CanvasLayer

signal pregunta_generada(pregunta: String, respuesta_correcta: int)

var a = 0
var b = 0
var pregunta_actual = ""
var tiempo = 60

@onready var tiempo_label = $TiempoLabel
@onready var pregunta_label = $"../PreguntaLabel/PreguntaLabel2"

func _ready():
	randomize()
	generar_pregunta()

func generar_pregunta():
	a = randi() % 10 + 1
	b = randi() % 10 + 1
	pregunta_actual = "%d + %d = ?" % [a, b]
	pregunta_label.text = pregunta_actual

	var correcta = a + b
	emit_signal("pregunta_generada", pregunta_actual, correcta)
