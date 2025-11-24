extends Area2D
signal respuesta_seleccionada(valor)

@onready var label = $respuestas
var valor = 0

func set_valor(v):
	valor = v
	if label:
		label.text = str(valor)
	else:
		print("ERROR: No se encontró el Label 'respuestas'")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == $"../../../personaje":  # Cambia por el nombre real de tu jugador
		emit_signal("respuesta_seleccionada", valor)
