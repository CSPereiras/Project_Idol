extends Area2D

const TIRO = preload("res://Corpos/Inimgos/Atirador/tiro_atirador.tscn")

var vida = 3
var podeAtirar = false
var corpo 
var ladoTiro
var posicaoTiro

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	verifica_vida()

func atinge(dano):
	vida -= dano

func verifica_vida():
	if vida <= 0:
		queue_free()

func _on_atirador_1_body_entered(body):
	if(body.name == "Idol" and !body.imunidade):
		body.dano(1)

func _on_timer_tiro_timeout():
	if podeAtirar:
		var instanciaDoTiro;
		instanciaDoTiro = TIRO.instantiate()
		instanciaDoTiro.defineAlvo(corpo)
		instanciaDoTiro.global_position = posicaoTiro
		get_parent().add_child(instanciaDoTiro)
		instanciaDoTiro.defineLado(ladoTiro)
		$TimerTiro.start()

func _on_visao_esq_body_entered(body):
	if body.name == "Idol":
		ladoTiro = -1
		$SpriteAtirador.flip_h = false
		posicaoTiro = $PosicaoTiroEsq.global_position
		permisaoTiro()
		atribuiCorpo(body)

func _on_visao_dir_body_entered(body):
	if body.name == "Idol":
		ladoTiro = 1
		$SpriteAtirador.flip_h = true
		posicaoTiro = $PosicaoTiroDir.global_position
		permisaoTiro()
		atribuiCorpo(body)

func _on_visao_esq_body_exited(body):
	if body.name == "Idol":
		permisaoTiro()

func _on_visao_dir_body_exited(body):
	if body.name == "Idol":
		permisaoTiro()

func permisaoTiro():
	podeAtirar = not podeAtirar

func atribuiCorpo(c):
	corpo = c


