extends Area2D

const TIRO = preload("res://Corpos/Inimgos/Atirador/tiro_atirador.tscn")

var vida = 3 #auto-explicativo
var podeAtirar = false #indica a permissão de tiro do atirador
var taNaTela = false #indica se atirador aparece na tela
var alvo #variavel para armazenar a referência do alvo quando a mesma estiver no campo de visão
var ladoTiro #lado que o tiro deverá seguir
var posicaoTiro #posição da arma do tiro

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	verifica_vida()

#ativado quando o atirador leva dano
func atinge(dano):
	vida -= dano

#verifica quantas vida o atirador tem e, caso não haja, o mata
func verifica_vida():
	if vida <= 0:
		queue_free()

#infrige dano em caso de colisão
func _on_body_entered(body):
	if(body.name == "Idol" and !body.imunidade):
		body.dano(1)

#faz o atirador atira quando isso deve ser feito
func _on_timer_tiro_timeout():
	if podeAtirar and taNaTela:
		var instanciaDoTiro;
		instanciaDoTiro = TIRO.instantiate()
		instanciaDoTiro.defineAlvo(alvo)
		instanciaDoTiro.global_position = posicaoTiro
		get_parent().add_child(instanciaDoTiro)
		instanciaDoTiro.defineLado(ladoTiro)
		$TimerTiro.start()

#esses dois definem o lado que o atirador deverá olha
func _on_visao_esq_body_entered(body):
	if body.name == "Idol":
		ladoTiro = -1
		$SpriteAtirador.flip_h = false
		posicaoTiro = $PosicaoTiroEsq.global_position
		permisaoTiro()
		atribuiAlvo(body)
func _on_visao_dir_body_entered(body):
	if body.name == "Idol":
		ladoTiro = 1
		$SpriteAtirador.flip_h = true
		posicaoTiro = $PosicaoTiroDir.global_position
		permisaoTiro()
		atribuiAlvo(body)

#esse dois tiram a permissão do tiro quando o alvo sai do campo de visão
func _on_visao_esq_body_exited(body):
	if body.name == "Idol":
		permisaoTiro()
func _on_visao_dir_body_exited(body):
	if body.name == "Idol":
		permisaoTiro()

#muda a permissão do tiro
func permisaoTiro():
	podeAtirar = not podeAtirar

#estas funções atualizando o status sobre se o atirador tá na tela ou não
func _on_notificador_atirador_screen_entered():
	taNaTela = true
func _on_notificador_atirador_screen_exited():
	taNaTela = false

#define o alvo quando detectado
func atribuiAlvo(a):
	alvo = a


