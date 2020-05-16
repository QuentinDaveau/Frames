extends "./box_state.gd"


func update(delta: float) -> void:
	.update(delta)
	if owner.is_on_ground():
		emit_signal("finished", "idle")
