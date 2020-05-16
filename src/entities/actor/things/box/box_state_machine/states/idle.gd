extends "./box_state.gd"


func enter() -> void:
	owner.set_velocity(Vector2.ZERO)


func update(delta: float) -> void:
	.update(delta)
	if not owner.is_on_ground():
		emit_signal("finished", "fall")
