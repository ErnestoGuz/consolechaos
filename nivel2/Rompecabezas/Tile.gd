extends TextureButton

var number

signal tile_pressed
signal slide_completed

# Actualiza el número del tile
func set_text(new_number):
	number = new_number
	$Number/Label.text = str(number)

# Actualiza la imagen de fondo del tile
func set_sprite(new_frame, size, tile_size):
	var sprite = $Sprite2D
	update_size(size, tile_size)

	sprite.hframes = size
	sprite.vframes = size
	sprite.frame = new_frame

# Escala según el nuevo tamaño
func update_size(size, tile_size):
	var new_size = Vector2(tile_size, tile_size)
	size = new_size
	$Number.size = new_size
	$Number/ColorRect.size = new_size
	$Number/Label.size = new_size
	$Panel.size = new_size

	var to_scale = size * (new_size / $Sprite2D.texture.get_size())
	$Sprite2D.scale = to_scale

# Actualiza la textura completa del fondo
func set_sprite_texture(texture):
	$Sprite2D.texture = texture

# 📦 Mueve el tile a una nueva posición con interpolación moderna
func slide_to(new_position: Vector2, duration: float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", new_position, duration)
	tween.tween_callback(func(): emit_signal("slide_completed"))

# Muestra u oculta el número
func set_number_visible(state: bool):
	$Number.visible = state

# Cuando se presiona el tile
func _on_Tile_pressed():
	emit_signal("tile_pressed", number)

func _on_pressed() -> void:
	pass # Replace with function body.
