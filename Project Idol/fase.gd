extends Node2D

const parteCaminho = "/root/Fase/Atributos/GrupoV/"

var jogoValido = true
var numVidasReservas = 4

@onready var vidas = [get_node(parteCaminho + "Vida1"), get_node(parteCaminho + "Vida2"), 
	get_node(parteCaminho + "Vida3"), get_node(parteCaminho + "Vida4"), 
	get_node(parteCaminho + "Vida5")]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if jogoValido:
		atualizaCarregaTiro()

func _on_idol_tomou_dano():
	for i in range(numVidasReservas, $Idol.retornaVidas()-1, -1):
		if(i>=0):
			vidas[i].queue_free()
	numVidasReservas = $Idol.retornaVidas()-1

func atualizaCarregaTiro():
	$Atributos/CarregaTiro.value = $Idol.retornaCarregamento()

func _on_idol_morreu():
	jogoValido = false
