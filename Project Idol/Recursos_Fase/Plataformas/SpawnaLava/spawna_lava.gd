extends Marker2D

const GOTALAVA = preload("res://Recursos_Fase/Plataformas/SpawnaLava/gota_lava.tscn")

func _on_timer_sl_timeout():
	var instanciaDaGotaLava
	instanciaDaGotaLava = GOTALAVA.instantiate()
	get_parent().add_child(instanciaDaGotaLava)
	instanciaDaGotaLava.definePosInic(self.global_position)
	
