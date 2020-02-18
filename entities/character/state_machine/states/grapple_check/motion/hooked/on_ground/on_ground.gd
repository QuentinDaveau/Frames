extends "../grapple_motion.gd"

#export(NodePath) var GROUNDED_CHECK_PATH

const THRESHOLD_VELOCITY: float = 100.0

export(float) var MAX_VELOCITY = 450.0
export(float) var ACCELERATION = 0.3

var _jump_flag: bool = false

#onready var GROUNDED_CHECK = get_node(GROUNDED_CHECK_PATH)


func enter() -> void:
	set_velocity_limitations(MAX_VELOCITY, ACCELERATION)
	var motion: Vector2 = Vector2(_move_speed * get_input_direction().x, _velocity.y + (_gravity * _gravity_multiplier * get_physics_process_delta_time()))
	if _has_grapple_length(_velocity):
		if get_input_direction():
			emit_signal("finished", "move")
		else:
			emit_signal("finished", "idle")
		return
	if abs(get_velocity().rotated(-owner.global_position.angle_to_point(_rotation_point)).y) > THRESHOLD_VELOCITY:
		emit_signal("finished", "grapple_air")
		return
	_velocity = Vector2.ZERO
	.enter()


func handle_input(event) -> void:
	if event.is_action_pressed("game_jump"):
		_jump_flag = true
	.handle_input(event)


func update(delta) -> void:
#	if not owner.is_on_floor():
#		emit_signal("finished", "grapple_air")
	if !_grappled:
		if get_input_direction():
			emit_signal("finished", "move")
		else:
			emit_signal("finished", "idle")
		return
	if _jump_flag:
		_jump_flag = false
		emit_signal("finished", "jump")
		return
	var motion: Vector2 = Vector2(lerp(_velocity.x, _move_speed * get_input_direction().x, _move_acceleration), _velocity.y)
	
	if (_rotation_point - (owner.global_position + (motion * delta))).length() < (_rotation_point - owner.global_position).length():
		emit_signal("finished", "move")
		return
	if abs(get_velocity().rotated(-owner.global_position.angle_to_point(_rotation_point)).y) > THRESHOLD_VELOCITY:
		emit_signal("finished", "grapple_air")
		return
	
	_velocity = Vector2.ZERO
	.update(delta)
	

