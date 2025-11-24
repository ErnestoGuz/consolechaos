extends Label

signal respuesta_seleccionada(valor)

func _ready():
	mouse_filter = MOUSE_FILTER_PASS  # Permite detectar clics
	connect("gui_input", Callable(self, "_on_gui_input"))

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("respuesta_seleccionada", text.to_int())
