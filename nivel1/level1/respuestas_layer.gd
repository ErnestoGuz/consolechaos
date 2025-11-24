extends CanvasLayer

@export var respuesta_scene: PackedScene
@onready var hud_preguntas = $"../Node/personaje/Camera2D/CanvasLayerPreguntas"
@onready var jugador = $"../Node/personaje"

# Límites del mapa (tomados de la cámara)
const LIMIT_LEFT = -1
const LIMIT_TOP = 12
const LIMIT_RIGHT = 2500
const LIMIT_BOTTOM = 1400

var respuestas = []

func _ready():
	if respuesta_scene == null:
		push_error("respuesta_scene no está asignada en el inspector")
		return
	generar_respuestas()

# Generar respuestas nuevas alrededor del jugador
func generar_respuestas():
	# Limpiar respuestas viejas
	for r in respuestas:
		r.queue_free()
	respuestas.clear()

	var correct_answer = hud_preguntas.current_answer
	var opciones = [correct_answer]

	# Generar 5 incorrectas
	while opciones.size() < 6:
		var r = randi() % 20 + 1
		if r not in opciones:
			opciones.append(r)
	opciones.shuffle()

	var offset_max = Vector2(300, 350)
	for i in range(opciones.size()):
		var pos = _generar_posicion_valida(offset_max)
		var r_label = respuesta_scene.instantiate()
		r_label.position = pos
		add_child(r_label)
		r_label.call_deferred("set_valor", opciones[i])
		r_label.connect("respuesta_seleccionada", Callable(self, "_on_respuesta_seleccionada"))
		respuestas.append(r_label)

# Genera posición válida evitando superposición y respetando límites del mapa
func _generar_posicion_valida(offset_max: Vector2, intentos_max: int = 30) -> Vector2:
	var min_distance = 100  # distancia mínima entre respuestas
	var pos = Vector2.ZERO  # declarar antes del bucle
	
	for i in range(intentos_max):
		pos = jugador.global_position + Vector2(
			randf_range(-offset_max.x, offset_max.x),
			randf_range(-offset_max.y, offset_max.y)
		)

		# Limitar al mapa
		pos.x = clamp(pos.x, LIMIT_LEFT, LIMIT_RIGHT)
		pos.y = clamp(pos.y, LIMIT_TOP, LIMIT_BOTTOM)

		# Verificar distancia mínima con otras respuestas
		var valido = true
		for r in respuestas:
			if r.position.distance_to(pos) < min_distance:
				valido = false
				break

		if valido:
			return pos

	# Si no encuentra lugar válido tras varios intentos, devuelve la última posición calculada
	return pos

# Cuando una respuesta es seleccionada
func _on_respuesta_seleccionada(valor):
	if valor == hud_preguntas.current_answer:
		hud_preguntas.mostrar_correcto()
	else:
		hud_preguntas.mostrar_incorrecto()

	# Generar nueva pregunta en HUD
	hud_preguntas.generar_pregunta()

	# Reposicionar respuestas con nuevas opciones
	var correct_answer = hud_preguntas.current_answer
	var opciones = [correct_answer]
	while opciones.size() < 6:
		var r = randi() % 20 + 1
		if r not in opciones:
			opciones.append(r)
	opciones.shuffle()

	var offset_max = Vector2(300, 350)
	for i in range(respuestas.size()):
		var r_label = respuestas[i]
		var pos = _generar_posicion_valida(offset_max)
		r_label.position = pos
		r_label.call_deferred("set_valor", opciones[i])
