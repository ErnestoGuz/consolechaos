extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer  # asegúrate que AnimationPlayer está bajo este Control

func _ready():
	anim.play("animation")  # reemplaza con el nombre real de la animación
