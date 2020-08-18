extends Area2D

signal actor_entered(actor)
signal actor_exited(actor)

func _on_body_entered(body: Node) -> void:
	emit_signal("actor_entered", body)


func _on_body_exited(body: Node) -> void:
	emit_signal("actor_exited", body)
	
