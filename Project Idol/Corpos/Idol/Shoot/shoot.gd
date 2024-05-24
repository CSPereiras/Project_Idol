extends Area2D

const VELOCITY = 30

var posicao = Vector2.ZERO
var lado #variavel que define pra que lado andará o tiro

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	posicao.x += VELOCITY * delta * lado
	translate(posicao)

func defineLado(dirOuEsq):
	lado = dirOuEsq
	if lado < 0:
		$SpriteTiro.flip_h = true
		$SpriteTiro.flip_v = true

func _on_area_entered(area):
	if area.get_collision_layer() == 2:
		area.atinge(3)
	self.queue_free()

func _on_body_entered(body):
	self.queue_free()

func _on_notifica_se_ta_na_tela_screen_exited():
	self.queue_free()
