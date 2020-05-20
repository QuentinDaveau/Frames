extends Area2D

signal actor_entered(actor)
signal actor_exited(actor)


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	if body is Actor:
		emit_signal("actor_entered", body)


func _on_body_exited(body: Node) -> void:
	if body is Actor:
		emit_signal("actor_exited", body)
