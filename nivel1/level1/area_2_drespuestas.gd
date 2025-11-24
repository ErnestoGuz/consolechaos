extends Area2D
signal respuesta_seleccionada(valor)

var valor = 0
var label: Label = null

func _ready():
	# Buscar el Label dentro de este Area2D
	label = $respuestas
	if not label:
		print("ERROR ERROR: Label 'Respuestas' no encontrado en el Area2D")
	connect("body_entered", Callable(self, "_on_body_entered"))

func set_valor(v):
	valor = v
	if label:
		label.text = str(valor)
	else:
		print("ERROR: Label aún no listo")

func _on_body_entered(body):
	if body.name == "personaje":
		emit_signal("respuesta_seleccionada", valor)
