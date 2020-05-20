extends "bull_state.gd"


export(float) var _ACCELERATION: float = 5

var _charge_timer: float = 0.0


func enter() -> void:
	var hit = owner.move_and_collide(owner.get_velocity() * get_physics_process_delta_time(), true, true, true)
	if hit:
		hit(hit)
	owner.set_velocity(owner.get_velocity() * Vector2(-1, 1))
	.enter()


func update(delta) -> void:
	var _current_velocity: Vector2 = owner.get_velocity()
	if abs(_current_velocity.x) <= 1.0:
		emit_signal("finished", "idle")
	_current_velocity.x = lerp(_current_velocity.x, 0.0, _ACCELERATION * delta)
	owner.set_velocity(_current_velocity)
	.update(delta)
