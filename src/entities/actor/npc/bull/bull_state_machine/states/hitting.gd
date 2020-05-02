extends "bull_state.gd"


export(float) var _ACCELERATION: float = 5

var _charge_timer: float = 0.0


func enter() -> void:
	hit(owner.move_and_collide(_velocity * get_physics_process_delta_time(), true, true, true))
	_velocity.x = -_velocity.x
	.enter()


func update(delta) -> void:
	if abs(_velocity.x) <= 1.0:
		emit_signal("finished", "idle")
	_velocity.x = lerp(_velocity.x, 0.0, _ACCELERATION * delta)
	owner.move_and_collide(_velocity * delta)
	.update(delta)
