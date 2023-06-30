extends Camera2D

const IDOL = "/root/Fase/Idol"

@onready var idol = get_node(IDOL)

var move = false
var recebeIdolX = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if move and recebeIdolX:
		global_position.x = idol.global_position.x

func _on_ativa_camera_body_entered(_body):
	move = true

func _on_idol_morreu():
	recebeIdolX = false
