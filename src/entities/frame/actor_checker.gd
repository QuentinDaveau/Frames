extends Area2D

signal actor_entered(actor)
signal actor_exited(actor)

var first = true


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body: Node) -> void:
	if not body is Actor:
		return
	emit_signal("actor_entered", body)


func _on_body_exited(body: Node) -> void:
	if not body is Actor:
		return
	emit_signal("actor_exited", body)
	
