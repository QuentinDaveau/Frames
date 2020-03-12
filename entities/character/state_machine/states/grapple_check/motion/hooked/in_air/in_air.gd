extends "../grapple_motion.gd"

export(float) var MAX_VELOCITY = 10.0
export(float) var ACCELERATION = 0.3

var _angular_velocity: float = 0.0


func enter() -> void:
	_angular_velocity = get_velocity().rotated(-owner.global_position.angle_to_point(_rotation_point)).y
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	_calculate_velocity(get_physics_process_delta_time())
	.enter()
#	update(get_physics_process_delta_time())


func update(delta) -> void:
	if !_grappled:
		emit_signal("finished", "fall")
		return
	if owner.is_on_floor():
		emit_signal("finished", "grapple_ground")
		return
	if _has_grapple_length(_velocity + (Vector2.DOWN * _gravity * delta)):
		emit_signal("finished", "fall")
		return
	
	_calculate_velocity(delta)
	.update(delta)
	



func _calculate_velocity(delta: float) -> void:
	var force_vector = (Vector2.DOWN * _gravity * delta) + (Vector2.RIGHT * _move_speed * get_input_direction().x)
	var angle = owner.global_position.angle_to_point(_rotation_point)
	_angular_velocity = _angular_velocity + (force_vector).rotated(-angle).y
#	var teta = _angular_velocity * delta / _distance_left
#		pulling_force = abs(_angular_velocity * (1.0 - Vector2.RIGHT.rotated(teta).x) / delta)

	var next_point: Vector2 = _rotation_point + (Vector2.RIGHT.rotated(angle + ((_angular_velocity * delta) / _distance_left)) * _distance_left)
	set_velocity((next_point - owner.global_position) / delta)
#	_velocity = owner.move_and_slide((next_point - owner.global_position) / delta, UP)
#	else:
#		_velocity = owner.move_and_slide(_velocity + (Vector2.DOWN * _gravity * delta), UP)
	
