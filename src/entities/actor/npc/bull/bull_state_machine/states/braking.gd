extends "bull_state.gd"


export(float) var _DECELERATION: float = 4
export(float) var _COLLISION_THRESHOLD: float = 200

var _charge_timer: float = 0.0


func update(delta) -> void:
	var _current_velocity: Vector2 = owner.get_velocity()
	if abs(_current_velocity.x) <= 1.0:
		emit_signal("finished", "idle")
	_current_velocity.x = lerp(_current_velocity.x, 0.0, _DECELERATION * delta)
	owner.set_velocity(_current_velocity)
	.update(delta)
	var collision: KinematicCollision2D = owner.move_and_collide(_current_velocity * delta, true, true, true)
	if collision:
		if collision.normal.x != 0 && abs(_current_velocity.x) > _COLLISION_THRESHOLD:
			emit_signal("finished", "hitting")
