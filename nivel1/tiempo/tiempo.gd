extends Line2D

signal time_to_die

# Método público para disminuir la barra
func decrease(penalizacion: float = 5):
	var p = points
	p[1].x = max(p[1].x - penalizacion, 0) # evita valores negativos
	points = p
	queue_redraw()

	if p[1].x <= 0:
		emit_signal("time_to_die")
		$Timer.stop()
		get_tree().change_scene_to_file("res://Scenes/gamer_over.tscn")

# ✅ Nuevo: método público para aumentar la barra
func increase(bonus: float = 15):
	var p = points
	var max_width = 100  # puedes cambiar esto si tu barra máxima es distinta

	p[1].x = min(p[1].x + bonus, max_width)  # evita irse más allá del máximo
	points = p
	queue_redraw()

# Método interno, llamado por el Timer
func _on_timer_timeout():
	decrease()  # usa el método público

func reset_barra(longitud: float):
	var p = points
	p[1].x = longitud
	points = p
	queue_redraw()
	$Timer.stop()
	$Timer.start()
