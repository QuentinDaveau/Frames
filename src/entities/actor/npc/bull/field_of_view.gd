extends Area2D

signal character_entered()
signal character_exited()


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	if body.get_name() == "Character":
		emit_signal("character_entered")


func _on_body_exited(body: Node) -> void:
	if body.get_name() == "Character":
		emit_signal("character_exited", body.global_position)