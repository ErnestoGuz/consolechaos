extends Area2D

var showInteractionLabel = false
var escena_preguntas: PackedScene = preload("res://nivel3/preguntas.tscn")

func _process(delta):
	$Label.visible = showInteractionLabel
	
	if showInteractionLabel and Input.is_action_just_pressed("interact"):
		print("Interacción detectada, mostrando preguntas...")
		mostrar_preguntas()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		showInteractionLabel = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		showInteractionLabel = false


func mostrar_preguntas():
	var preguntas_ui = escena_preguntas.instantiate()

	# 🔹 Buscamos la escena actual del nivel (donde está el jugador y la cámara)
	var nivel_actual = get_tree().current_scene
	
	# 🔹 Buscamos el CanvasLayer o HUD donde queremos mostrar las preguntas
	var canvas_layer = nivel_actual.get_node("CanvasLayer")
	
	# Si el CanvasLayer no existe, lo creamos
	if not canvas_layer:
		canvas_layer = CanvasLayer.new()
		canvas_layer.name = "CanvasLayer"
		nivel_actual.add_child(canvas_layer)
	
	# 🔹 Añadimos la UI de preguntas dentro del CanvasLayer
	canvas_layer.add_child(preguntas_ui)

	# 🔹 Ajustamos el tamaño para ocupar toda la pantalla
	if preguntas_ui is Control:
		preguntas_ui.visible = true
		preguntas_ui.set_anchors_preset(Control.PRESET_FULL_RECT)

	# 🔹 Conectamos la señal para cerrar preguntas
	if preguntas_ui.has_signal("cerrar_preguntas"):
		preguntas_ui.connect("cerrar_preguntas", Callable(self, "_on_cerrar_preguntas").bind(preguntas_ui))

	# 🔹 (Opcional) desactivar movimiento del jugador mientras responde
	if nivel_actual.has_node("Node/personaje"):
		nivel_actual.get_node("Node/personaje").set_process(false)
	
	print("✅ Escena de preguntas mostrada en el HUD correctamente:", preguntas_ui.name)


func _on_cerrar_preguntas(preguntas_ui):
	print("🔹 Cerrando panel de preguntas...")
	queue_free()
	preguntas_ui.queue_free()

	# 🔹 Reactivar jugador
	var nivel_actual = get_tree().current_scene
	if nivel_actual.has_node("Node/personaje"):
		nivel_actual.get_node("Node/personaje").set_process(true)
