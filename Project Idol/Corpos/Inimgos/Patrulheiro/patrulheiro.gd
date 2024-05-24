extends Area2D

const SPEED = 2

var direction = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	global_position.x += direction * SPEED

#recebe sinal de detecção de colisão do patrulheiro e aplica o dano na Idol
func _on_body_entered(body):
	if(body.name == "Idol" and !body.imunidade):
		body.dano(1)
