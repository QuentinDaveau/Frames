extends "./box_state.gd"

export(float) var _push_speed: float = 10.0

var _push_direction: Vector2


func set_push_direction(direction: Vector2) -> void:
	_push_direction = direction


func get_push_velocity() -> Vector2:
	return _push_direction.normalized() * _push_speed


func update(delta: float) -> void:
	.update(delta)
	if not owner.is_on_ground():
		emit_signal("finished", "fall")


func apply_movement(delta) -> void:
	var _current_velocity: Vector2 = owner.get_velocity()
	_current_velocity.x = _push_direction.normalized().x * _push_speed
	_current_velocity.y += GRAVITY * delta
	owner.set_velocity(_current_velocity)
	owner.move(delta)
