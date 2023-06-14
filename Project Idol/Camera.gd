extends Camera2D

const IDOL = "/root/Fase/Idol"

var move = false

func _ready():
	drag_vertical_offset = 0.0
	enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move:
		enabled = true
	else:
		enabled = false

func _on_idol_primeira_metade():
	move = not move
