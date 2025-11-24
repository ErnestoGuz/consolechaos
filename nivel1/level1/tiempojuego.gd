extends Node2D


@onready var barra_tiempo = $CanvasLayer/Tiempo
@onready var hud = $CanvasLayer

func _ready():
	barra_tiempo.connect("time_to_die", Callable(self, "_on_time_over"))
	hud.connect("pregunta_generada", Callable(self, "_on_pregunta_generada"))

	# Inicia la primera barra
	barra_tiempo.reset_barra(100)
	
func _on_time_over():
	print("Tiempo terminado, nueva pregunta")
	hud.generar_pregunta()
	barra_tiempo.reset_barra(100)
	
func _on_pregunta_generada(pregunta, respuesta_correcta):
	var contenedor = $Respuestas
	contenedor.queue_free_children()  # borra las anteriores respuestas

	var respuestas = []
	respuestas.append(respuesta_correcta)
	
	# Generar 3 respuestas incorrectas
	while respuestas.size() < 4:
		var r = randi() % 20 + 1
		if r != respuesta_correcta and not r in respuestas:
			respuestas.append(r)
	
	respuestas.shuffle()

	# Crear nodos Label o Button en posiciones aleatorias
	for i in range(respuestas.size()):
		var label = Label.new()
		label.text = str(respuestas[i])
		label.position = Vector2(randf_range(50, 400), randf_range(100, 300))
		contenedor.add_child(label)

		# Puedes conectar para verificar si es la correcta
		label.connect("gui_input", Callable(self, "_on_respuesta_seleccionada").bind(respuestas[i], respuesta_correcta))
func _on_respuesta_seleccionada(event, valor, correcta):
	if event is InputEventMouseButton and event.pressed:
		if valor == correcta:
			print("✅ Correcto!")
			$Line2D.reset_barra(100)
			$CanvasLayer.generar_pregunta()
		else:
			print("❌ Incorrecto")
