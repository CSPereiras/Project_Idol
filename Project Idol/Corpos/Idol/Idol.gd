extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = 13 #-500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vidas = 5
var pulo = 0
var imunidade = false
var impulsoDano = false
var impulsoPulo = true
var podePular = true
var colisao

signal morreu
signal tomouDano

func _physics_process(_delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	# Handle Jump.
	if Input.is_action_pressed("accept") and is_on_floor() and !impulsoDano and impulsoPulo and podePular:
		jump()
		$TimerImpulsoPulo.start()
		podePular = false
	
	if Input.is_action_just_released("accept") or !impulsoPulo:
		jump_cut()
		if is_on_floor():
			impulsoPulo = true
	
	if is_on_ceiling():
		impulsoPulo = false
	
	if !Input.is_action_pressed("accept") and is_on_floor():
		podePular = true
	
	self.global_position.y -= pulo
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction and !impulsoDano:
		velocity.x = direction * SPEED
		$Sprite_Idol.set_flip_h(direction+1)
	elif impulsoDano:
		if direction:
			velocity.x = SPEED * 3 * -direction
		else:
			velocity.x = SPEED * 3 * -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if vidas < 1:
		emit_signal("morreu")
		queue_free()

	move_and_slide()

func jump():
	pulo += JUMP_VELOCITY

func jump_cut():
	pulo = 0

func _on_patrulheiro_body_entered(body):
	if(body.name == "Idol" and !body.imunidade):
		dano()

func dano():
	impulsoDano = true
	$TimerDano.start()
	vidas -= 1
	imunidade = true
	$TimerImunidade.start()
	emit_signal("tomouDano")

func _on_timer_timeout():
	impulsoDano = false

func _on_timer_imunidade_timeout():
	imunidade = false

func _on_timer_impulso_pulo_timeout():
	impulsoPulo = false

