extends Area2D

func _on_body_entered(body):
	body.adicionaVida()
	self.queue_free()
