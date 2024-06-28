extends CharacterBody2D

const SPEED = 300 #velocidade de locomoção
const JUMP_VELOCITY = 13 #velocidade do pulo
const TIRO = preload("res://Corpos/Idol/Shoot/shoot.tscn") #nó do tiro
const MAXVIDAS = 5 #o máximo de vidas queaIdol pode ter

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vidas = 5 #auto-explicativo
var pulo = 0
var imunidade = false #indica se leva dano ou não
var impulsoDano = false #indica quando a Idol terá impulso por dano
var impulsoPulo = true #indica quando a Idol terá impulso por pulo
var podePular = true #indica se a Idol poderá pular 
var podeAtirar = true #indica se a Idol poderá atirar

signal morreu #indica que morreu
signal tomouDano #indica que tomou dano
signal pegouVida #indica que pegou vida

func _physics_process(_delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	#detecta se o topo da personagem toca em alguma coisa e desliga o impulso do pulo se for verdade
	if is_on_ceiling():
		impulsoPulo = false
	
	# Ativação do pulo
	if Input.is_action_pressed("accept") and is_on_floor() and !impulsoDano and impulsoPulo and podePular:
		jump()
		$TimerImpulsoPulo.start()
		podePular = false
	
	# Desativação do pulo
	if Input.is_action_just_released("accept") or !impulsoPulo:
		jump_cut()
		if is_on_floor():
			impulsoPulo = true
	
	#volta a permissão do pulo
	if !Input.is_action_pressed("accept") and is_on_floor():
		podePular = true
	
	self.global_position.y -= pulo
	
	#faz funcionar o tiro
	if Input.is_action_just_pressed("tiro"):
		atira()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and !impulsoDano:
		if is_on_wall() and ((direction == -1 and get_wall_normal().x > 0) or (direction == 1 and get_wall_normal().x < 0)):
			direction = 0
		velocity.x = direction * SPEED
		if direction:
			$Sprite_Idol.set_flip_h(direction+1)
	elif impulsoDano:
		if direction:
			velocity.x = SPEED * 3 * -direction
		else:
			velocity.x = SPEED * 3 * -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack"):
		ataca()
	
	define_lado_da_espada()
	
	move_and_slide()
	
	verifica_vida()

#mecânica de pulo
func jump():
	pulo += JUMP_VELOCITY

#mecânica para cortar o pulo
func jump_cut():
	pulo = 0

#tira a vida da Idol
func dano(dano):
	impulsoDano = true
	$TimerAnimaDano.start()
	$TimerDano.start()
	vidas -= dano
	imunidade = true
	$TimerImunidade.start()
	emit_signal("tomouDano")

#gera animação que indica que a Idol acabou de tomar dano
func _on_timer_anima_dano_timeout():
	if $Sprite_Idol.is_visible():
		$Sprite_Idol.hide()
	else:
		$Sprite_Idol.show()

#adiciona uma vida a mais
func adicionaVida():
	if vidas < MAXVIDAS:
		vidas += 1
		emit_signal("pegouVida")

#retona o número de vidas
func retornaVidas():
	return vidas

#verifica se a Idol tem vidas restantes e a mata caso contrário
func verifica_vida():
	if vidas < 1:
		emit_signal("morreu")
		queue_free()

#para com o impulso da Idol ao tomar dano
func _on_timer_timeout():
	impulsoDano = false

#termina a imunidade da Idol ao tomar dano
func _on_timer_imunidade_timeout():
	imunidade = false
	$TimerAnimaDano.stop()
	if !$Sprite_Idol.is_visible():
		$Sprite_Idol.show()

#termina com o impulso do pulo
func _on_timer_impulso_pulo_timeout():
	impulsoPulo = false

#aplica o dano no inimigo pela espada
func _on_espada_area_entered(area):
	area.atinge(1)

#faz a espada voltar ao comportamento padrão após o ataque
func _on_timer_espada_timeout():
	$Espada.monitoring = false
	$Espada/Espada2.visible = false

#define lado da espada
func define_lado_da_espada():
	if $Sprite_Idol.flip_h:
		$Espada.position = $Espada/EspadaNaDireita.position
		$Espada/Espada2.flip_v = false
		$Espada/Espada2.flip_h = false
	else:
		$Espada.position = $Espada/EspadaNaEsquerda.position
		$Espada/Espada2.flip_v = true
		$Espada/Espada2.flip_h = true

#executa o ataque da Idol
func ataca():
	$Espada.monitoring = true
	$TimerEspada.start()
	$Espada/Espada2.visible = true

#executa o tiro
func atira():
	if podeAtirar:
		var instanciaDoTiro 
		instanciaDoTiro = TIRO.instantiate()
		get_parent().add_child(instanciaDoTiro)
		instanciaDoTiro.defineLado(verificaLadoTiro())
		instanciaDoTiro.global_position = defineLadoTiro()
		podeAtirar = false
		$TimerTiro.start()

#verifica para que lado o tiro deverá seguir
func verificaLadoTiro():
	if $Sprite_Idol.flip_h:
		return 1
	else:
		return -1

#define qual lado o tiro deverá seguir
func defineLadoTiro():
	if verificaLadoTiro() > 0:
		return $PosicaoTiroEsq.global_position
	else:
		return $PosicaoTiroDir.global_position

#devolve a permissão para atirar
func _on_timer_tiro_timeout():
	podeAtirar = true

#retorna o status atual da "mana" do tiro
func retornaCarregamento():
	return 30 - $TimerTiro.get_time_left()

#verifica se a Idol entra em contato com algum tilemap danoso
func _on_area_dano_espinho_body_entered(body):
	dano(vidas)
