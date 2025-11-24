extends CanvasLayer

@onready var preguntas_label = $preguntas
@onready var barra_tiempo = $"../Tiempo"

var current_answer = 0  # esta es la respuesta correcta

func _ready():
	generar_pregunta()

func generar_pregunta():
	var a = randi() % 10 + 1
	var b = randi() % 10 + 1
	var operacion = randi() % 3
	var question_text = ""

	match operacion:
		0:
			question_text = str(a) + " + " + str(b)
			current_answer = a + b
		1:
			question_text = str(a) + " - " + str(b)
			current_answer = a - b
		2:
			question_text = str(a) + " × " + str(b)
			current_answer = a * b

	preguntas_label.text = question_text

# Estos métodos los llama RespuestasLayer para feedback visual
func mostrar_correcto():
	print("¡Correcto!")
	if barra_tiempo:
		barra_tiempo.increase(10)
	# Aquí luego puedes agregar animación verde, sonido, etc.

func mostrar_incorrecto():
	print("Incorrecto")
	if barra_tiempo:
		barra_tiempo.decrease(5)  # penaliza tiempo
