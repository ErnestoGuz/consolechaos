extends Area2D

@export var enemigo_path: NodePath # enemigo asignado desde el editor
var enemigo
@onready var jugador = null

func _ready():
	enemigo = get_node(enemigo_path)
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		jugador = body
		if enemigo:
			enemigo.jugador = jugador
			enemigo.activo = true
			print("Jugador entró a ", name, " → Enemigo activado")

func _on_body_exited(body):
	if body == jugador:
		if enemigo:
			enemigo.activo = false
			print("Jugador salió de ", name, " → Enemigo detenido")
		jugador = null
