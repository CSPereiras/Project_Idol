extends Area2D

const SPEED = 2

var direction = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position.x += direction * SPEED
