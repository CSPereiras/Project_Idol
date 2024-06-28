extends Area2D

const VELOCITY = 750

var posicao = Vector2.ZERO
var lado #variavel que define pra que lado andará o tiro
var alvo #variavel que define o alvo do tiro
var yVelocity #variavel que determina a velocidade vertical

func _ready():
	#calculo da veliciado vertical
	yVelocity = alvo.global_position.y - self.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#movimentação do tiro
	posicao.x += VELOCITY * delta * lado
	posicao.y += yVelocity * delta
	translate(posicao.normalized() * 15)

#o alvo é identificado
func defineAlvo(body):
	alvo = body

#o lado por onde o tiro deverá seguido é definido
func defineLado(l):
	lado = l

#implica dano e desaparece
func _on_body_entered(body):
	if body.get_collision_layer() == 1:
		body.dano(2)
	self.queue_free()

#desaparece quando sai da tela
func _on_notifica_se_ta_na_tela_screen_exited():
	self.queue_free()
