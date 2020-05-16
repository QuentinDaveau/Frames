extends "bull_state.gd"


export(float) var _DECELERATION: float = 4
export(float) var _COLLISION_THRESHOLD: float = 200

var _charge_timer: float = 0.0


func update(delta) -> void:
	if abs(_velocity.x) <= 1.0:
		emit_signal("finished", "idle")
	_velocity.x = lerp(_velocity.x, 0.0, _DECELERATION * delta)
	var collision: KinematicCollision2D = owner.move_and_collide(_velocity * delta, true, true, true)
	if collision:
		if collision.normal.x != 0 && abs(_velocity.x) > _COLLISION_THRESHOLD:
			emit_signal("finished", "hitting")
	owner.move_and_collide(_velocity * delta)
	.update(delta)
