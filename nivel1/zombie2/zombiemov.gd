extends CharacterBody2D
class_name zombie

var speed = 190

var player = null

func _ready():
	player = get_tree().get_nodes_in_group("personaje")[0]
	
func _process(delta: float) -> void:
	follow()
	
func follow():
	if player != null:
		velocity = position.direction_to(player.position) * speed
		
		move_and_slide()
