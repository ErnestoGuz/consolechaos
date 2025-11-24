extends Control

signal cerrar_preguntas

@onready var label_pregunta = $MarginContainer/VBoxContainer/Label
@onready var boton1 = $Respuesta1
@onready var boton2 = $Respuesta2
@onready var boton3 = $Respuesta3
@onready var boton4 = $Respuesta4
@onready var label_correctas = $"../../CanvasPregu/VBoxContainer/LabelCorrectas"
@onready var label_incorrectas = $"../../CanvasPregu/VBoxContainer/LabelIncorrectas"

var respuesta_correcta = ""
var preguntas = []

var ya_inicializado = false
var correctas = 0
var incorrectas = 0

func _ready():
	if ya_inicializado:
		return  # ⚠️ Evita volver a reiniciar las preguntas o los contadores
	
	randomize()

	# 📘 Banco de preguntas con 4 opciones cada una (la primera es la correcta)
	preguntas = [
		# 🧲 FÍSICA
		["¿Qué magnitud mide la fuerza?", "Newtons", "Julios", "Watts", "Pascales"],
		["¿Cuál es la fórmula de la velocidad?", "v = d / t", "v = t / d", "v = d × t", "v = d + t"],
		["¿Qué ley enuncia que toda acción tiene una reacción igual y opuesta?", "Tercera ley de Newton", "Primera ley de Newton", "Segunda ley de Newton", "Ley de la gravedad"],
		["¿Qué tipo de energía tiene un objeto en movimiento?", "Energía cinética", "Energía potencial", "Energía térmica", "Energía luminosa"],
		["¿Cuál es el valor aproximado de la aceleración de la gravedad en la Tierra?", "9.8 m/s²", "10 m/s²", "8.9 m/s²", "9.0 m/s²"],
		["¿Qué instrumento se usa para medir la corriente eléctrica?", "Amperímetro", "Voltímetro", "Barómetro", "Termómetro"],
		["¿Qué tipo de onda es el sonido?", "Mecánica longitudinal", "Electromagnética", "Transversal", "De radio"],

		# 🏛️ HISTORIA
		["¿En qué año comenzó la Revolución Mexicana?", "1910", "1921", "1900", "1917"],
		["¿Quién fue el primer presidente de México?", "Guadalupe Victoria", "Benito Juárez", "Porfirio Díaz", "Antonio López de Santa Anna"],
		["¿En qué año Cristóbal Colón llegó a América?", "1492", "1502", "1485", "1510"],
		["¿Qué civilización construyó Chichén Itzá?", "Los mayas", "Los aztecas", "Los olmecas", "Los incas"],
		["¿Qué tratado puso fin a la Primera Guerra Mundial?", "Tratado de Versalles", "Tratado de París", "Tratado de Tordesillas", "Tratado de Berlín"],
		["¿Quién lideró la independencia de Estados Unidos?", "George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
		["¿En qué año cayó el Imperio Romano de Occidente?", "476 d.C.", "500 d.C.", "410 d.C.", "600 d.C."],

		# 🌍 GEOGRAFÍA
		["¿Cuál es el río más largo del mundo?", "Nilo", "Amazonas", "Yangtsé", "Misisipi"],
		["¿Qué capa de la Tierra es la más externa?", "Corteza", "Manto", "Núcleo externo", "Núcleo interno"],
		["¿Cuál es el país más grande del mundo?", "Rusia", "Canadá", "China", "Estados Unidos"],
		["¿Qué línea divide la Tierra en hemisferio norte y sur?", "Ecuador", "Meridiano de Greenwich", "Trópico de Cáncer", "Trópico de Capricornio"],
		["¿Cuál es el desierto más grande del mundo?", "Sahara", "Gobi", "Kalahari", "Atacama"],
		["¿Qué país tiene más población?", "China", "India", "Estados Unidos", "Indonesia"],
		["¿Cuál es el océano más pequeño?", "Ártico", "Índico", "Atlántico", "Pacífico"],

		# 🔢 ÁLGEBRA
		["Si 2x + 5 = 11, ¿cuánto vale x?", "3", "2", "4", "6"],
		["Resuelve: 3(x + 2) = 9", "x = 1", "x = 2", "x = 0", "x = 3"],
		["¿Cuál es el valor de x en la ecuación 5x = 20?", "4", "5", "3", "6"],
		["Simplifica: 2x + 3x", "5x", "6x", "2x", "3x"],
		["Si y = 2x + 1 y x = 4, ¿cuánto vale y?", "9", "8", "7", "10"],
		["Resuelve: (x/2) = 6", "x = 12", "x = 8", "x = 6", "x = 10"],
		["Factoriza: x² + 5x + 6", "(x + 2)(x + 3)", "(x + 1)(x + 6)", "(x + 3)(x + 4)", "(x + 1)(x + 5)"],
		["Si a = 3 y b = 4, ¿cuál es el valor de a² + b²?", "25", "12", "7", "24"]
	]

	generar_pregunta()
	ya_inicializado = true


func generar_pregunta():
	var seleccion = preguntas[randi() % preguntas.size()]
	var pregunta_texto = seleccion[0]
	respuesta_correcta = seleccion[1]

	label_pregunta.text = pregunta_texto

	# 🔹 Copiar las 4 respuestas y mezclarlas
	var opciones = seleccion.slice(1, 4 + 1)
	opciones.shuffle()

	# 🔹 Asignar a los botones
	boton1.text = opciones[0]
	boton2.text = opciones[1]
	boton3.text = opciones[2]
	boton4.text = opciones[3]


func _on_respuesta_1_pressed(): verificar_respuesta(boton1.text)
func _on_respuesta_2_pressed(): verificar_respuesta(boton2.text)
func _on_respuesta_3_pressed(): verificar_respuesta(boton3.text)
func _on_respuesta_4_pressed(): verificar_respuesta(boton4.text)


func verificar_respuesta(valor):
	if valor == respuesta_correcta:
		label_pregunta.text = "✅ ¡Correcto!"
		GLOBAL.correctas += 1
	else:
		label_pregunta.text = "❌ Incorrecto, era: " + respuesta_correcta
		GLOBAL.incorrectas += 1
	
	actualizar_contadores()
	await get_tree().create_timer(1.5).timeout

	# ⚙️ Condiciones de resultado
	if GLOBAL.correctas >= 5:
		get_tree().change_scene_to_file("res://Scenes/gamer_over.tscn")  # Cambia a tu escena del siguiente nivel
	elif GLOBAL.incorrectas >= 3:
		get_tree().change_scene_to_file("res://nivel3/gameover/game_over_v_2.tscn")  # Cambia a la escena de Game Over
	else:
		# Si aún no cumple ninguna condición, cierra el panel
		emit_signal("cerrar_preguntas")


func actualizar_contadores():
	label_correctas.text = "Correctas: " + str(GLOBAL.correctas)
	label_incorrectas.text = "Incorrectas: " + str(GLOBAL.incorrectas)
