extends Area2D

const VELOCITY = 750

var posicao = Vector2.ZERO
var lado #variavel que define pra que lado andará o tiro
var alvo
var yVelocity

func _ready():
	yVelocity = alvo.global_position.y - self.global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	posicao.x += VELOCITY * delta * lado
	posicao.y += yVelocity * delta
	translate(posicao.normalized() * 15)

func defineAlvo(body):
	alvo = body

func defineLado(l):
	lado = l

func _on_body_entered(body):
	if body.get_collision_layer() == 1:
		body.dano(2)
	self.queue_free()

func _on_notifica_se_ta_na_tela_screen_exited():
	self.queue_free()
