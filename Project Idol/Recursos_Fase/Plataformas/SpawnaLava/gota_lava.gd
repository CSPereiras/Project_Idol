extends Area2D

const MAX = 600

var velocidade = 15
var altura_inicial 
var altura_max 
var subindo = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.global_position.y <= altura_inicial:
		if self.global_position.y < altura_max:
			subindo = false
			$SpriteGL.flip_v = true
	else:
		queue_free()
	
	mudAltura()

func mudAltura():
	if subindo:
		self.global_position.y -= velocidade
	else:
		self.global_position.y += velocidade

func definePosInic(posicao):
	self.global_position = posicao
	altura_inicial = posicao.y
	altura_max = altura_inicial - MAX

func _on_body_entered(body):
	body.dano(3)
