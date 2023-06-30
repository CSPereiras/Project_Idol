extends Node2D

const parteCaminho = "/root/Fase/Vidas/GrupoV/"

var numVidasReservas = 4

@onready var vidas = [get_node(parteCaminho + "Vida1"), get_node(parteCaminho + "Vida2"), 
	get_node(parteCaminho + "Vida3"), get_node(parteCaminho + "Vida4"), 
	get_node(parteCaminho + "Vida5")]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_idol_tomou_dano():
	vidas[numVidasReservas].queue_free()
	numVidasReservas -= 1
