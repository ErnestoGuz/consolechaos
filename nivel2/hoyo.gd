extends Area2D

@export var target_node: NodePath        
@export var cooldown_time: float = 0.25  # Evita re-disparo inmediato

var _cooldown := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if target_node == NodePath():
		push_warning("Asigna 'target_node' en el inspector al TeleportTarget.")

func _on_body_entered(body: Node) -> void:
	if _cooldown:
		return
	if body.is_in_group("Player"):
		print("Entró:", body.name)
		var target := get_node_or_null(target_node)
		if target == null:
			push_error("El 'target_node' no existe. Verifica la ruta asignada.")
			return
		# Teletransportar
		body.global_position = target.global_position
		
		_cooldown = true
		await get_tree().create_timer(cooldown_time).timeout
		_cooldown = false
