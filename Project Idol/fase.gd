extends Node2D

const PARTECAMINHO = "/root/Fase/Atributos/GrupoV/" 
const CORACAO = preload("res://Recursos_Fase/Vidas/Vida.tscn") #nó do sprite do coração
const PROXIMAFASE = "res://teste/Node2D.tscn" #a próxima "fase" [deverá ser modificado]

var jogoValido = true #indica se o jogo continua ou não
var numVidasReservas = 4 #indica quantas vidas tem alem da que está senfo utilizada pela Idol

#vetor que armazena os nós de todos os sprites de corações (vidas)
@onready var vidas = [get_node(PARTECAMINHO + "Vida1"), get_node(PARTECAMINHO + "Vida2"), 
	get_node(PARTECAMINHO + "Vida3"), get_node(PARTECAMINHO + "Vida4"), 
	get_node(PARTECAMINHO + "Vida5")]

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if jogoValido:
		atualizaCarregaTiro() 
	else:
		#define que o jogo poderá ser reiniciado
		if Input.is_action_pressed("start"):
			get_tree().reload_current_scene()

#atualiza o label para o número atual de vidas da Idol em caso de dano
func _on_idol_tomou_dano():
	for i in range(numVidasReservas, $Idol.retornaVidas()-1, -1):
		if(i>=0):
			var vidaExcluida = vidas[i]
			vidas[i] = vidas[i].position
			vidaExcluida.queue_free()
	numVidasReservas = $Idol.retornaVidas()-1

#atualiza o label para a quantidade atual de "mana" do tiro da Idol
func atualizaCarregaTiro():
	$Atributos/CarregaTiro.value = $Idol.retornaCarregamento()

#muda o status do jogo, indicando que acabou
func _on_idol_morreu():
	jogoValido = false

#atualiza o label para o número atual de vidas da Idol em caso de vida coletada
func _on_idol_pegou_vida():
	numVidasReservas += 1
	var posicao = vidas[numVidasReservas]
	var instanciaDoCoracao
	instanciaDoCoracao = CORACAO.instantiate()
	$Atributos/GrupoV.add_child(instanciaDoCoracao)
	instanciaDoCoracao.position = posicao
	vidas[numVidasReservas] = instanciaDoCoracao

#faz a transição de fase
func _on_fim_de_nivel_body_entered(body):
	get_tree().change_scene_to_file(PROXIMAFASE)
