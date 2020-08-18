extends LogicBody

var _pressed: bool = false


func _on_Area2D_body_entered(body: Node) -> void:
	if _pressed:
		return
	_pressed = true
	emit_signal("state_update", _pressed)


func _on_Area2D_body_exited(body: Node) -> void:
	if not _pressed:
		return
	if $Area2D.get_overlapping_bodies().size() > 1:
		return
	_pressed = false
	emit_signal("state_update", _pressed)
